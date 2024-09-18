const express = require("express");
const router = express.Router();

const PictureController = require("../controllers/pictureController");
const { model } = require("mongoose");
const upload = require("../config/multer")

router.post("/", upload.single("file"), PictureController.create);

router.get("/", PictureController.retrum);

router.delete("/:id", PictureController.delete);

module.exports = router;
