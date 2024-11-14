require('dotenv').config();

const mongoose = require("mongoose")
const app = require("./app");

const PORT = process.env.PORT;

const DB = process.env.DB_URL

mongoose.connect(DB)
  .then(() => {
    console.log("Conexão Bem-sucedida");

    app.listen(PORT, "0.0.0.0", () => {
      console.log(`Conectado na porta ${PORT}`);
    });
  })
  .catch((e) => {
    console.log(e);
  });