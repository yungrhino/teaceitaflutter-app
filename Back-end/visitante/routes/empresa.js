require('dotenv').config();
const path = require('path');
const express = require("express");
const bcryptjs = require("bcryptjs");
const Empresa = require("../models/empresa"); // Modelo Empresa
const empresaRouter = express.Router();
const jwt = require('jsonwebtoken');
const auth = require("../middleware/auth");
const nodemailer = require('nodemailer');

let tempEmpresaData = {};

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.USER_EMAIL,
    pass: process.env.USER_PASSWORD
  },
});

empresaRouter.get("/redefinirSenha", (req, res) => {
  res.sendFile(path.join(__dirname, 'redefinirSenha.html'));
});

// Solicitação de Senha
empresaRouter.post("/api/solicitarRedefinicaoSenha", async (req, res) => {
  try {
    const { email } = req.body;
    const empresa = await Empresa.findOne({ email });

    if (!empresa) {
      return res.status(404).json({ error: "Empresa não encontrada." });
    }

    if (empresa.resetTokenUsed) {
      empresa.resetTokenUsed = false;
      await empresa.save();
    }

    const restToken = jwt.sign({ id: empresa.id }, "RestPassword", { expiresIn: "5m" });
const restLink = `http://15.229.250.5:3000/redefinirSenha?token=${restToken}`;
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
      <title>TEAceita - Recuperação de Senha</title>
      <link rel="icon" href="https://raw.githubusercontent.com/yungrhino/teaceita-assets/refs/heads/main/assets/favicon.ico" type="image/x-icon">
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
        <img src="https://raw.githubusercontent.com/yungrhino/teaceita-assets/refs/heads/main/assets/teaceita.png" alt="Logo TEAceita" class="logo">
        <h2>Recuperação de Senha</h2>
        <p>Olá, ${empresa.nome},</p>
        <p>Clique no botão abaixo para redefinir sua senha:</p>
        <a href="${restLink}" class="btn">Redefinir Senha</a>
        <p style="margin-top: 20px;">Este link é válido por 5 minutos.</p>
        <p>Atenciosamente,<br>TEAceita</p>
      </div>
    </body>
    </html>
  `,
};


    await transporter.sendMail(mailOptions);
    res.status(200).json({ message: "Link de redefinição de senha enviado para seu E-mail." });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Rota para redefinir senha
empresaRouter.post("/api/redefinirSenha", async (req, res) => {
  try {
    const { token, novaSenha } = req.body;

    const decoded = jwt.verify(token, "RestPassword");
    const empresa = await Empresa.findById(decoded.id);

    if (!empresa) {
      return res.status(404).json({ error: "Empresa não encontrada." });
    }

    empresa.resetTokenUsed = true;
    await empresa.save();

    const hashedPassword = await bcryptjs.hash(novaSenha, 8);

    empresa.password = hashedPassword;
    await empresa.save();

    res.status(200).json({ message: "Senha redefinida com sucesso!" });
  } catch (error) {
    res.status(400).json({ error: "Token inválido ou expirado." });
  }
});

// Cadastro de Empresa
empresaRouter.post("/api/cadastroEmpresa", async (req, res) => {
  try {
    const { name, email, password, cnpj, endereco } = req.body;

    const existingEmpresa = await Empresa.findOne({ email });
    if (existingEmpresa) {
      return res.status(400).json({ msg: "Este e-mail já existe!" });
    }

    tempEmpresaData[email] = { name, cnpj, endereco, password };

    const hashedPassword = await bcryptjs.hash(password, 8);

    const verificationToken = jwt.sign({ email, name, cnpj, endereco }, "verificationKey", { expiresIn: "30m" });
const verificationLink = `http://15.229.250.5:3000/api/verificarEmail?token=${verificationToken}`;
const mailOptions = {
  from: process.env.USER_EMAIL,
  to: email,
  subject: 'Verifique seu e-mail - TEAceita',
  html: `
    <!DOCTYPE html>
    <html lang="pt-BR">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>TEAceita - Verificação de E-mail</title>
      <link rel="icon" href="https://raw.githubusercontent.com/yungrhino/teaceita-assets/refs/heads/main/assets/favicon.ico" type="image/x-icon">
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

        /* Contêiner principal */
        .container {
          background-color: #fff;
          padding: 20px 30px;
          border-radius: 8px;
          box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
          width: 100%;
          max-width: 400px;
          text-align: center;
        }

        /* Logo */
        .logo {
          max-width: 150px;
          margin: 0 auto 20px;
        }

        /* Botão de verificação */
        .btn {
          display: inline-block;
          padding: 10px 20px;
          margin-top: 20px;
          color: #black;
          background-color: #4aad65;
          text-decoration: none;
          font-size: 16px;
          border-radius: 5px;
          transition: background-color 0.3s;
        }

        .btn:hover {
          background-color: #0056b3;
        }

        .btn:active {
          background-color: #004494;
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
        <img src="https://raw.githubusercontent.com/yungrhino/teaceita-assets/refs/heads/main/assets/teaceita.png" alt="Logo TEAceita" class="logo">
        <h2>Verificação de E-mail</h2>
        <p>Olá, ${name}!</p>
        <p>Obrigado por se cadastrar no TEAceita. Clique no botão abaixo para ativar sua conta:</p>
        <a href="${verificationLink}" class="btn">Verificar E-mail</a>
        <p>Se você não solicitou este e-mail, ignore esta mensagem.</p>
        <p>Atenciosamente,<br>Equipe TEAceita</p>
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

// Verificação de e-mail
empresaRouter.get("/api/verificarEmail", async (req, res) => {
  try {
    const { token } = req.query;
    if (!token) {
      return res.status(400).json({ error: "Token não fornecido." });
    }

    const decoded = jwt.verify(token, "verificationKey");
    const { email } = decoded;

    const empresaData = tempEmpresaData[email];
    if (!empresaData) {
      return res.status(400).json({ error: "Dados da empresa não encontrados." });
    }

    if (!empresaData.password) {
      return res.status(400).json({ error: "Senha não definida." });
    }

    const hashedPassword = await bcryptjs.hash(empresaData.password, 8);
    const empresa = new Empresa({
      email,
      password: hashedPassword,
      name: empresaData.name,
      cnpj: empresaData.cnpj,
      endereco: empresaData.endereco,
      isVerified: true
    });
    await empresa.save();

    delete tempEmpresaData[email];

    res.sendFile(path.join(__dirname, "/verificationSuccess.html"));
  } catch (e) {
    console.error("Erro durante a verificação:", e);
    res.status(400).json({ error: "Token de verificação inválido ou expirado.", details: e.message });
  }
});

// Login de Empresa
empresaRouter.post("/api/loginEmpresa", async (req, res) => {
  try {
    const { email, password } = req.body;

    const empresa = await Empresa.findOne({ email });
    if (!empresa) {
      return res.status(400).json({ msg: "Empresa não encontrada" });
    }

    const isMatch = await bcryptjs.compare(password, empresa.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Senha incorreta" });
    }

    const token = jwt.sign({ id: empresa._id }, "passwordKey");
    res.json({ token, ...empresa._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Validação de Token para Empresa
empresaRouter.post("/tokenEmpresaValido", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const empresa = await Empresa.findById(verified.id);
    if (!empresa) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Obter Empresa
empresaRouter.get("/", auth, async (req, res) => {
  const empresa = await Empresa.findById(req.user);
  res.json({ ...empresa._doc, token: req.token });
});

module.exports = empresaRouter;
