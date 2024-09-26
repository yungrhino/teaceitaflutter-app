const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');

let mongoServer;

module.exports.setUpDB = async () => {
  if (mongoose.connection.readyState !== 0) {
    await mongoose.disconnect();  // Desconecta se já estiver conectado
  }

  mongoServer = await MongoMemoryServer.create();
  const uri = mongoServer.getUri();

  await mongoose.connect(uri, { useNewUrlParser: true, useUnifiedTopology: true });
};

module.exports.tearDownDB = async () => {
  await mongoose.disconnect();  // Desconecta o Mongoose
  await mongoServer.stop();  // Para o servidor de banco de dados em memória
};
