const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
    name: {
        required: true,
        type: String,
        trim: true,
    },
    sobrenome: {
        required: true,
        type: String
    },
    email: {
        required: true,
        type: String,
        trim: true,
        validate: {
            validator: (value) => {
                const re =
                    /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            message: "Please enter a valid email address",
        },
    },
    password: {
        required: true,
        type: String,
    },
    datanascimento: {
        required: true,
        type: String
    },
    cpf: {
        required: true,
        type: String,
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
        default: 'visitante' 
    },

});

const User = mongoose.model("User", userSchema);
module.exports = User;