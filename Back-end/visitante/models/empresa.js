const mongoose = require("mongoose");

const empresaSchema = mongoose.Schema({
    name: {
        required: true,
        type: String,
        trim: true,
    },
    cnpj: {
        required: true,
        type: String,
        unique: true,
        validate: {
            validator: (valor) => {
                const re = /^\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}$/;
                return re.test(valor);
            },
            message: "Por favor, insira um CNPJ válido no formato XX.XXX.XXX/XXXX-XX",
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
    isVerified: {
        type: Boolean,
        default: false
    },
    resetTokenUsed: {
        type: Boolean,
        default: false
    },
    tipo: { 
        type: String, 
        default: 'empresa' 
    },
});

const Empresa = mongoose.model("Empresa", empresaSchema);
module.exports = Empresa;
