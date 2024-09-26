const express = require("express");
const authRoute = require("./routes/auth");

const app = express();

app.use(express.json());
app.use(authRoute);

module.exports = app;  // Exporta o app para ser utilizado nos testes
