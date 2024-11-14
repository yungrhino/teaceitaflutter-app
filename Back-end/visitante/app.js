const express = require("express");
const authRoute = require("./routes/auth");
const empresaRouter = require("./routes/empresa");
const psicologoRouter = require("./routes/psicologo")

const app = express();

app.use(express.json());
app.use(authRoute);
app.use(empresaRouter);
app.use(psicologoRouter);
module.exports = app; 
