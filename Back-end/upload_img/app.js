const express = require("express");
const app = express();

require("dotenv").config();
require("./db");

const PictureRouter = require("./routes/picture")
const port = process.env.PORT || 3000;

app.use("/pictures", PictureRouter);

app.listen(port, () => {
    console.log(`o servidor esta rodando ${port}`);
    
} )
