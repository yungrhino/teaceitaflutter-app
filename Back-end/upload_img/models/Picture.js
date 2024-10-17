const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const PictureSchema = new Schema({

  src: {
    type: String, 
    required: true 
  },

  description: {
    type: String,
    required: true,
  }
  
});

module.exports = mongoose.model("Picture", PictureSchema);