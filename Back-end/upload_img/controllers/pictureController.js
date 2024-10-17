const Picture = require("../models/Picture");

const fs = require("fs")

exports.create = async (req, res) => {
  try {
    const { description } = req.body;
    const file = req.file;

    const picture = new Picture({
      description,
      src: file.path.replace(/\\/g, '/'),
    });

    await picture.save();

    res.json({picture, message: "Imagem salva com sucesso!"})
  } catch (error) {
    res.status(500).json({message: "Erro ao salvar a Imagen!"})
  }
};

exports.retrum = async(req, res) => {
  try {
    const pictures = await Picture.find();

    const baseUrl = `http://192.168.1.107:4000/`; // Defina a URL base

    const picturesWithFullUrls = pictures.map(p => ({
      _id: p._id,
      src: baseUrl + p.src.replace(/\\/g, '/'), // Construindo a URL corretamente
      description: p.description,
      __v: p.__v,
    }));

    res.json(picturesWithFullUrls);
  } catch (error) {
    res.status(500).json({ message: "Erro ao buscar Imagens!" });
  }
};

exports.delete = async(req , res) => {
  try {
    const picture = await Picture.findById(req.params.id);

    if(!picture) {
      return res.status(404).json({message: "Imagem não encontrada"});
    };

    fs.unlinkSync(picture.src)
    await Picture.findByIdAndDelete(req.params.id);

    res.json({message: "Imagem removida com sucesso!"})
  } catch (error) {
    res.status(500).json({message: "Erro ao excluir Imagens!"})
  }
};

