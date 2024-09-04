const express = require("express");
const bcryptjs = require("bcryptjs");
const User = require("../models/user");
const authRouter = express.Router();

// Sign Up
authRouter.post("/api/signup", async (req, res) => {
    try {
      const { name, email, password, datanascimento, cpf,sobrenome } = req.body;
  
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        return res
          .status(400)
          .json({ msg: "Está E-mail já existe!" });
      }
  
      const hashedPassword = await bcryptjs.hash(password, 4);
  
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

module.exports = authRouter;
