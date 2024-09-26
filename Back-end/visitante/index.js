const mongoose = require("mongoose")
const app = require("./app");

const PORT = process.env.PORT || 3000;

const DB = 
"mongodb+srv://mario081:fUVl8H9FAjCsMPpb@visitante.sejl4.mongodb.net/?retryWrites=true&w=majority&appName=Visitante";

mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");

    app.listen(PORT, "0.0.0.0", () => {
      console.log(`Connected at port ${PORT}`);
    });
  })
  .catch((e) => {
    console.log(e);
  });