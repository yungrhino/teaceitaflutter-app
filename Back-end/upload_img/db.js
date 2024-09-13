const mongoose = require("mongoose");

require("dotenv").config();

mongoose.set("strictQuery", true);

main().catch((err) => console.log(err));

async function main() {
  await mongoose.connect(
    `mongodb+srv://${process.env.USER}:${process.env.PASSWORD}@imgs.egiqt.mongodb.net/?retryWrites=true&w=majority&appName=imgs`
  );

  console.log("Conectado com sucesso!");
}

module.exports = main;