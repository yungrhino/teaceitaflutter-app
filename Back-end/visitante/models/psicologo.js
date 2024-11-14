const mongoose = require("mongoose");

const psicologoSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
  },
  crp: {  // Registro profissional (CRP)
    required: true,
    type: String,
    unique: true,
    validate: {
      validator: (valor) => {
        const re = /^CRP-\d{2}\/\d{5}$/;  // Validação do formato CRP
        return re.test(valor);
      },
      message: "Por favor, insira um CRP válido no formato CRP-XX/XXXXX",
    },
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (valor) => {
        const re =
          /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$/i;
        return valor.match(re);
      },
      message: "Por favor, insira um endereço de e-mail válido",
    },
  },
  password: {
    required: true,
    type: String,
  },
  endereco: {
    required: true,
    type: String,
    trim: true,
  },
  especialidade: {  // A especialidade do psicólogo
    required: true,
    type: String,
  },
  isVerified: {  // Campo para indicar se o e-mail foi verificado
    type: Boolean,
    default: false,
  },
  resetTokenUsed: {  // Campo para verificar se o token de redefinição foi utilizado
    type: Boolean,
    default: false,
  },
});

const Psicologo = mongoose.model("Psicologo", psicologoSchema);
module.exports = Psicologo;
