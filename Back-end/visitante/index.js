const express = require("express")
const mongoose = require("mongoose")
const authRoute = require("./routes/auth");

const PORT = process.env.PORT || 3000;
const app = express();

app.use(express.json());
app.use(authRoute);

const DB = 
"mongodb+srv://mario081:fUVl8H9FAjCsMPpb@visitante.sejl4.mongodb.net/?retryWrites=true&w=majority&appName=Visitante";

mongoose    
    .connect(DB)
    .then(() => {
        console.log("Connection Successful");
        
    })
    .catch((e) => {
        console.log(e);
        
    })

    app.listen(PORT, "0.0.0.0", () =>{
        console.log(`connected at port ${PORT}`);
        
    });