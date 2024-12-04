const bcrypt = require('bcryptjs');
const express = require("express");
const jwt = require('jsonwebtoken');
const Visitante = require('../models/user');
const Psicologo = require('../models/psicologo');
const Empresa = require('../models/empresa');
const loginRouter = express.Router();

loginRouter.post('/api/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    let user = await Visitante.findOne({ email: email });
    
    if (!user) {
      user = await Psicologo.findOne({ email: email });
    }
    
    if (!user) {
      user = await Empresa.findOne({ email: email });
    }
    
    if (!user) {
      return res.status(400).json({ message: 'Usuário não encontrado!' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Senha incorreta!' });
    }

    const token = jwt.sign({ id: user._id, tipo: user.tipo }, 'secret', { expiresIn: '1h' });

     res.json({ token, ...user._doc});
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Erro interno do servidor' });
  }
});

module.exports = loginRouter;