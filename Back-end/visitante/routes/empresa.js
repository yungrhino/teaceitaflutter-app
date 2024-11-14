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
    const restLink = `http://localhost:3000/redefinirSenha?token=${restToken}`;
    const mailOptions = {
      from: process.env.USER_EMAIL,
      to: email,
      subject: "Recuperação de senha",
      html: `
        <p>Olá, ${empresa.nome},</p>
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
    const { name, email, password, cnpj, telefone, endereco } = req.body;

    const existingEmpresa = await Empresa.findOne({ email });
    if (existingEmpresa) {
      return res.status(400).json({ msg: "Este e-mail já existe!" });
    }

    tempEmpresaData[email] = { name, cnpj, telefone, endereco, password };

    const hashedPassword = await bcryptjs.hash(password, 8);

    const verificationToken = jwt.sign({ email, name, cnpj, telefone, endereco }, "verificationKey", { expiresIn: "30m" });

    const verificationLink = `http://localhost:3000/api/verificarEmail?token=${verificationToken}`;
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
      telefone: empresaData.telefone,
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