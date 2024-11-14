require('dotenv').config();
const path = require('path');
const express = require("express");
const bcryptjs = require("bcryptjs");
const User = require("../models/user");
const authRouter = express.Router();
const jwt = require('jsonwebtoken');
const auth = require("../middleware/auth");
const nodemailer = require('nodemailer');

let tempUserData = {};

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.USER_EMAIL,
    pass: process.env.USER_PASSWORD
  },
});

authRouter.get("/resetPassword", (req, res) => {
  res.sendFile(path.join(__dirname, 'resetPassword.html'));
});

//Solicitação de Senha
authRouter.post("/api/restPasswordRequest", async (req, res) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({ error: "Usuário não encontrado." })
    }

    if (user.resetTokenUsed) {
      user.resetTokenUsed = false;
      await user.save();
    }

    const restToken = jwt.sign({ id: user.id }, "RestPassword", { expiresIn: "5m" });
    const restLink = `http://localhost:3000/resetPassword?token=${restToken}`;
    const mailOptions = {
      from: process.env.USER_EMAIL,
      to: email,
      subject: "Recuperação de senha",
      html: `
        <p>Olá, ${user.name},</p>
        <p>Clique no link abaixo para redefinir sua senha:</p>
        <a href="${restLink}">Redefinir Senha</a>
        <p>Este link é válido por 1 hora.</p>`,
    };

    await transporter.sendMail(mailOptions);
    res.status(200).json({ message: "Link de redefinição de senha enviado para seu E-mail." })
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

//Rota para redefinir senha
authRouter.post("/api/resetPassword", async (req, res) => {
  try {
    const { token, newPassword } = req.body;

    const decoded = jwt.verify(token, "RestPassword");
    const user = await User.findById(decoded.id);

    if (!user) {
      return res.status(404).json({ error: "Usuário não encontrado." })
    }

    user.resetTokenUsed = true;
    await user.save();

    const hashedPassword = await bcryptjs.hash(newPassword, 8);

    user.password = hashedPassword;
    await user.save();

    res.status(200).json({ message: "Senha redefinida com sucesso!" });
  } catch (error) {
    res.status(400).json({ error: "Token inválido ou expirado." });
  }
});

// CRIANDO USER
authRouter.post("/api/signUp", async (req, res) => {
  try {
    const { name, email, password, datanascimento, cpf, sobrenome } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ msg: "Está E-mail já existe!" });
    }

    tempUserData[email] = { name, datanascimento, cpf, sobrenome, password };

    const hashedPassword = await bcryptjs.hash(password, 8);

    const verificationToken = jwt.sign({ email, name, datanascimento, cpf, sobrenome }, "verificationKey", { expiresIn: "30m" });

    const verificationLink = `http://localhost:3000/api/verifyEmail?token=${verificationToken}`;
    const mailOptions = {
      from: process.env.USER_EMAIL,
      to: email,
      subject: 'Verifique seu e-mail',
      html: `
      <div style="font-family: Arial, sans-serif; color: #333;">
        <h2>Olá, ${name}!</h2>
        <p>Obrigado por se cadastrar. Por favor, verifique seu e-mail para ativar sua conta.</p>
        <p>Clique no botão abaixo para verificar seu e-mail:</p>
        <a href="${verificationLink}" style="
          display: inline-block;
          padding: 10px 20px;
          margin-top: 10px;
          color: #fff;
          background-color: #007bff;
          text-decoration: none;
          border-radius: 5px;
        ">Verificar E-mail</a>
        <p style="margin-top: 20px;">Se você não solicitou este e-mail, ignore esta mensagem.</p>
        <p>Atenciosamente,<br>TEAceita</p>
      </div>
    `,
    };

    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error("Erro ao enviar e-mail:", error);
        return res.status(500).json({ error: "Erro ao enviar o e-mail.", details: error.message });
      } else {
        console.log("E-mail de verificação enviado: " + info.response);
        res.json({ msg: "E-mail de verificação enviado. Por favor, verifique seu e-mail." });
      }
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//VERIFICADO E-MAIL
authRouter.get("/api/verifyEmail", async (req, res) => {
  try {
    const { token } = req.query;
    if (!token) {
      return res.status(400).json({ error: "Token não fornecido." });
    }

    const decoded = jwt.verify(token, "verificationKey");
    const { email } = decoded;

    const userData = tempUserData[email];
    if (!userData) {
      return res.status(400).json({ error: "Dados do usuário não encontrados." });
    }

    if (!userData.password) {
      return res.status(400).json({ error: "Senha não definida." });
    }

    const hashedPassword = await bcryptjs.hash(userData.password, 8);
    const user = new User({
      email,
      password: hashedPassword,
      name: userData.name,
      sobrenome: userData.sobrenome,
      datanascimento: userData.datanascimento,
      cpf: userData.cpf,
      isVerified: true
    });
    await user.save();

    delete tempUserData[email];

    res.sendFile(path.join(__dirname, "/verificationSuccess.html"));
  } catch (e) {
    console.error("Erro durante a verificação:", e);
    res.status(400).json({ error: "Token de verificação inválido ou expirado.", details: e.message });
  }
});

// LOGANDO USER

authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ msg: "Usuário não encontrado" });
    }

    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Senha incorreta" });
    }

    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// VALIDANDO TOKEN USER
authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// get user
authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  res.json({ ...user._doc, token: req.token });
});

module.exports = authRouter;
