const express = require("express");
const app = express();
const path = require("path");

require("dotenv").config();
require("./db");

const PictureRouter = require("./routes/picture")
const port = process.env.PORT;

app.use("/pictures", PictureRouter);

app.use("/uploads", express.static(path.join(__dirname, "uploads")));

app.listen(port, () => {
    console.log(`o servidor esta rodando ${port}`);
    
} )
