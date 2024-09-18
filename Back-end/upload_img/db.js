const mongoose = require("mongoose");

require("dotenv").config();

mongoose.set("strictQuery", true);

async function main() {
  await mongoose.connect(
    `mongodb+srv://${process.env.USER}:${process.env.PASSWORD}@imgs.egiqt.mongodb.net/?retryWrites=true&w=majority&appName=imgs`
  );

  console.log("Conectado com sucesso!");
}

main().catch((err) => console.log(err)
);

module.exports = main;