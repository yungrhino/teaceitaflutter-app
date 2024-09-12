const express = require("express");
const bcryptjs = require("bcryptjs");
const User = require("../models/user");
const authRouter = express.Router();

// Sign Up
authRouter.post("/api/signUp", async (req, res) => {
  try {
    const { name, email, password, datanascimento, cpf, sobrenome } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "Está E-mail já existe!" });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
      email,
      password: hashedPassword,
      name,
      datanascimento,
      cpf,
      sobrenome
    });
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Sign In

authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!User) {
      return res
        .status(400)
        .json({ msg: "O Usuário ja existente" });
    }

    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res
        .status(400)
        .json({ msg: "Senha incorreta" });
    }

    const token = jwt.sing({ id: user._id }, "passwordKey");
    res.json({ token, ...user._doc });
  } catch (e) {
    res
      .status(500)
      .json({ error: e.message });
  }
});

module.exports = authRouter;
