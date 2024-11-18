require('dotenv').config();
const path = require('path');
const express = require("express");
const bcryptjs = require("bcryptjs");
const Psicologo = require("../models/psicologo");
const psicologoRouter = express.Router();
const jwt = require('jsonwebtoken');
const auth = require("../middleware/auth");
const nodemailer = require('nodemailer');

let tempPsicologoData = {};

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.USER_EMAIL,
    pass: process.env.USER_PASSWORD
  },
});

psicologoRouter.get("/resetPassword", (req, res) => {
  res.sendFile(path.join(__dirname, 'resetPassword.html'));
});

// Solicitação de Senha
psicologoRouter.post("/api/restPasswordRequest", async (req, res) => {
  try {
    const { email } = req.body;
    const psicologo = await Psicologo.findOne({ email });

    if (!psicologo) {
      return res.status(404).json({ error: "Psicólogo não encontrado." });
    }

    if (psicologo.resetTokenUsed) {
      psicologo.resetTokenUsed = false;
      await psicologo.save();
    }

    const restToken = jwt.sign({ id: psicologo.id }, "RestPassword", { expiresIn: "5m" });
    const restLink = `http://localhost:3000/resetPassword?token=${restToken}`;
    const mailOptions = {
      from: process.env.USER_EMAIL,
      to: email,
      subject: "Recuperação de senha",
      html: `
        <p>Olá, ${psicologo.name},</p>
        <p>Clique no link abaixo para redefinir sua senha:</p>
        <a href="${restLink}">Redefinir Senha</a>
        <p>Este link é válido por 1 hora.</p>`,
    };

    await transporter.sendMail(mailOptions);
    res.status(200).json({ message: "Link de redefinição de senha enviado para seu E-mail." });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Rota para redefinir senha
psicologoRouter.post("/api/resetPassword", async (req, res) => {
  try {
    const { token, newPassword } = req.body;

    const decoded = jwt.verify(token, "RestPassword");
    const psicologo = await Psicologo.findById(decoded.id);

    if (!psicologo) {
      return res.status(404).json({ error: "Psicólogo não encontrado." });
    }

    psicologo.resetTokenUsed = true;
    await psicologo.save();

    const hashedPassword = await bcryptjs.hash(newPassword, 8);

    psicologo.password = hashedPassword;
    await psicologo.save();

    res.status(200).json({ message: "Senha redefinida com sucesso!" });
  } catch (error) {
    res.status(400).json({ error: "Token inválido ou expirado." });
  }
});

// Cadastro de Psicólogo
psicologoRouter.post("/api/cadastroPsicologo", async (req, res) => {
  try {
    const { name, email, password, endereco, especialidade, crp } = req.body;

    const existingPsicologo = await Psicologo.findOne({ email });
    if (existingPsicologo) {
      return res.status(400).json({ msg: "Este E-mail já existe!" });
    }

    tempPsicologoData[email] = { name, endereco, especialidade, crp, password };

    const hashedPassword = await bcryptjs.hash(password, 8);

    const verificationToken = jwt.sign({ email, name, endereco, especialidade, crp }, "verificationKey", { expiresIn: "30m" });

    const verificationLink = `http://localhost:3000/api/verificarPsicologo?token=${verificationToken}`;
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

// Verificação de e-mail
psicologoRouter.get("/api/verificarPsicologo", async (req, res) => {
  try {
    const { token } = req.query;
    if (!token) {
      return res.status(400).json({ error: "Token não fornecido." });
    }

    const decoded = jwt.verify(token, "verificationKey");
    const { email } = decoded;

    const userData = tempPsicologoData[email];
    if (!userData) {
      return res.status(400).json({ error: "Dados do psicólogo não encontrados." });
    }

    if (!userData.password) {
      return res.status(400).json({ error: "Senha não definida." });
    }

    const hashedPassword = await bcryptjs.hash(userData.password, 8);
    const psicologo = new Psicologo({
      email,
      password: hashedPassword,
      name: userData.name,
      endereco: userData.endereco,
      especialidade: userData.especialidade,
      crp: userData.crp,
      isVerified: true
    });
    await psicologo.save();

    delete tempPsicologoData[email];

    res.sendFile(path.join(__dirname, "/verificationSuccess.html"));
  } catch (e) {
    console.error("Erro durante a verificação:", e);
    res.status(400).json({ error: "Token de verificação inválido ou expirado.", details: e.message });
  }
});

// Login de Psicólogo
psicologoRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const psicologo = await Psicologo.findOne({ email });
    if (!psicologo) {
      return res.status(400).json({ msg: "Psicólogo não encontrado" });
    }

    const isMatch = await bcryptjs.compare(password, psicologo.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Senha incorreta" });
    }

    const token = jwt.sign({ id: psicologo._id }, "passwordKey");
    res.json({ token, ...psicologo._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Validação de Token para Psicólogo
psicologoRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const psicologo = await Psicologo.findById(verified.id);
    if (!psicologo) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Obter Psicólogo
psicologoRouter.get("/", auth, async (req, res) => {
  const psicologo = await Psicologo.findById(req.user);
  res.json({ ...psicologo._doc, token: req.token });
});

module.exports = psicologoRouter;