const request = require('supertest');
const mongoose = require('mongoose');
const app = require('../app');
const User = require('../models/user');
const bcryptjs = require('bcryptjs');
const { setUpDB, tearDownDB } = require('../memoriaDB/setupTestDB');

beforeAll(async () => {
  await setUpDB(); 
});

afterAll(async () => {
  await tearDownDB();  
});

beforeEach(async () => {
  await User.deleteMany();
});

describe('Auth API', () => {
  it('Deve registrar um novo usuário', async () => {
    const res = await request(app).post('/api/signUp').send({
      name: 'mario',
      sobrenome: 'oliveira',
      email: 'mario@gmail.com',
      password: 'test123',
      datanascimento: '1990-01-01',
      cpf: '12345678900'
    });

    expect(res.statusCode).toEqual(200);
    expect(res.body).toHaveProperty('_id');
    expect(res.body).toHaveProperty('email', 'mario@gmail.com');
  });

  it('Não deve registrar um usuário com email duplicado', async () => {
    const user = new User({
      name: 'Test User',
      sobrenome: 'Sobrenome',
      email: 'mario@gmail.com',
      password: 'test123',
      datanascimento: '1990-01-01',
      cpf: '12345678900'
    });
    await user.save();

    const res = await request(app).post('/api/signUp').send({
      name: 'Another User',
      sobrenome: 'Sobrenome',
      email: 'mario@gmail.com',
      password: 'test123',
      datanascimento: '1990-01-01',
      cpf: '12345678900'
    });

    expect(res.statusCode).toEqual(400);
    expect(res.body).toHaveProperty('msg', 'Está E-mail já existe!');
  });

  it('Deve logar um usuário existente', async () => {
    const user = new User({
      name: 'Test User',
      sobrenome: 'Sobrenome',
      email: 'mario@gmail.com',
      password: await bcryptjs.hash('test123', 8),
      datanascimento: '1990-01-01',
      cpf: '12345678900'
    });
    await user.save();

    const res = await request(app).post('/api/signin').send({
      email: 'mario@gmail.com',
      password: 'test123'
    });

    expect(res.statusCode).toEqual(200);
    expect(res.body).toHaveProperty('token');
    expect(res.body).toHaveProperty('email', 'mario@gmail.com');
  });

  it('Deve retornar erro para senha incorreta', async () => {
    const user = new User({
      name: 'Test User',
      sobrenome: 'Sobrenome',
      email: 'mario@gmail.com',
      password: await bcryptjs.hash('test123', 8),
      datanascimento: '1990-01-01',
      cpf: '12345678900'
    });
    await user.save();

    const res = await request(app).post('/api/signin').send({
      email: 'mario@gmail.com',
      password: 'wrongpassword'
    });

    expect(res.statusCode).toEqual(400);
    expect(res.body).toHaveProperty('msg', 'Senha incorreta');
  });
});
