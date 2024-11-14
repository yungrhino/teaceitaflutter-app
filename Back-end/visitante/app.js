const express = require("express");
const authRoute = require("./routes/auth");
const empresaRouter = require("./routes/empresa");

const app = express();

app.use(express.json());
app.use(authRoute);
app.use(empresaRouter);
module.exports = app; 
