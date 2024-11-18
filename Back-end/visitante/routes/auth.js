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
  subject: "Recuperação de senha - TEAceita",
  html: `
    <!DOCTYPE html>
    <html lang="pt-BR">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>TEAceita - Redefinir Senha</title>
      <link rel="icon" href="https://raw.githubusercontent.com/yungrhino/teaceitaflutter-app/9c904c71b463ecb323e0b5b58ffec0116534a3f0/Back-end/visitante/assets/favicon.ico?token=GHSAT0AAAAAAC2RJ72HSMT5KATCZXCPWOD2ZZ3ULZA" type="image/x-icon">
      <style>
        /* Estilos gerais */
        body {
          font-family: Arial, sans-serif;
          background-color: #f4f4f4;
          margin: 0;
          padding: 0;
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
        }

        /* Estilização do contêiner */
        .container {
          background-color: #fff;
          padding: 20px 30px;
          border-radius: 8px;
          box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
          width: 100%;
          max-width: 400px;
          text-align: center;
        }

        /* Imagem */
        .logo {
          max-width: 150px;
          margin: 0 auto 20px;
        }

        /* Título */
        h2 {
          text-align: center;
          color: #333;
          margin-bottom: 20px;
        }

        /* Botão */
        .btn {
          display: inline-block;
          background-color: #4aad65;
          color: white;
          text-decoration: none;
          padding: 10px 20px;
          font-size: 16px;
          border-radius: 5px;
          cursor: pointer;
          transition: background-color 0.3s;
        }

        .btn:hover {
          background-color: #3b8f53;
        }

        .btn:active {
          background-color: #347c49;
        }

        /* Texto adicional */
        p {
          color: #555;
          line-height: 1.5;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <img src="https://raw.githubusercontent.com/yungrhino/teaceita-assets/refs/heads/main/assets/teaceita.png" alt="Logo TEAceita" class="logo">
        <h2>Redefinir Senha</h2>
        <p>Olá, ${user.name},</p>
        <p>Clique no botão abaixo para redefinir sua senha:</p>
        <a href="${restLink}" class="btn">Redefinir Senha</a>
        <p>Este link é válido por 5 minutos.</p>
      </div>
    </body>
    </html>
  `,
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
  subject: "Verifique seu e-mail - TEAceita",
  html: `
    <!DOCTYPE html>
    <html lang="pt-BR">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>TEAceita - Verifique seu E-mail</title>
      <link rel="icon" href="https://raw.githubusercontent.com/yungrhino/teaceitaflutter-app/9c904c71b463ecb323e0b5b58ffec0116534a3f0/Back-end/visitante/assets/favicon.ico?token=GHSAT0AAAAAAC2RJ72HSMT5KATCZXCPWOD2ZZ3ULZA" type="image/x-icon">
      <style>
        /* Estilos gerais */
        body {
          font-family: Arial, sans-serif;
          background-color: #f4f4f4;
          margin: 0;
          padding: 0;
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
        }

        /* Estilização do contêiner */
        .container {
          background-color: #fff;
          padding: 20px 30px;
          border-radius: 8px;
          box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
          width: 100%;
          max-width: 400px;
          text-align: center;
        }

        /* Imagem */
        .logo {
          max-width: 150px;
          margin: 0 auto 20px;
        }

        /* Título */
        h2 {
          text-align: center;
          color: #333;
          margin-bottom: 20px;
        }

        /* Botão */
        .btn {
          display: inline-block;
          background-color: #4aad65;
          color: white;
          text-decoration: none;
          padding: 10px 20px;
          font-size: 16px;
          border-radius: 5px;
          cursor: pointer;
          transition: background-color 0.3s;
          margin-top: 10px;
        }

        .btn:hover {
          background-color: #3b8f53;
        }

        .btn:active {
          background-color: #347c49;
        }

        /* Texto adicional */
        p {
          color: #555;
          line-height: 1.5;
          margin: 10px 0;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <img src="https://raw.githubusercontent.com/yungrhino/teaceitaflutter-app/9c904c71b463ecb323e0b5b58ffec0116534a3f0/Back-end/visitante/assets/teaceita.png?token=A72DWSJDDOSE7WLP66BYSHLHHORK4" alt="Logo TEAceita" class="logo">
        <h2>Olá, ${name}!</h2>
        <p>Obrigado por se cadastrar na TEAceita. Por favor, verifique seu e-mail para ativar sua conta.</p>
        <p>Clique no botão abaixo para verificar seu e-mail:</p>
        <a href="${verificationLink}" class="btn">Verificar E-mail</a>
        <p style="margin-top: 20px;">Se você não solicitou este e-mail, ignore esta mensagem.</p>
        <p>Atenciosamente,<br>TEAceita</p>
      </div>
    </body>
    </html>
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
