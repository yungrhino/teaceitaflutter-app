const mongoose = require("mongoose");

require("dotenv").config();

mongoose.set("strictQuery", true);

const DB = process.env.DB_URI;


 mongoose.connect(DB)
 .then(() => console.log("Connected to MongoDB"))


.catch((e) => {
  console.log(e)
}
);
