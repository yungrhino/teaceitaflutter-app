import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teaceita/models/user.dart';
import 'package:teaceita/providers/user_provider.dart';
import 'package:teaceita/services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static void signOutUser(BuildContext context) {
    AuthService().signOut(context);
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user;
  List<Map<String, String>> imageData = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.107:4000/pictures'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('Dados recebidos: $jsonData');

        if (jsonData is List) {
          setState(() {
            imageData = jsonData
                .map((item) {
                  return {
                    'src': item['src'] as String,
                    'description': item['description'] as String,
                  };
                })
                .toList()
                .cast<Map<String, String>>();
          });
        } else {
          print('A resposta não é uma lista: $jsonData');
        }
      } else {
        print('Erro ao buscar imagens: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar imagens: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: _buildDrawer(),
      body: Center(
        child: ListView.builder(
          itemCount: imageData.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    imageData[index]['src']!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      imageData[index]['description']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Método que constrói o Drawer (menu lateral)
  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.green, // Cor do cabeçalho
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alinha os textos à esquerda
              children: [
                const Text(
                  'Menu', // Título do menu
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                    height: 10), // Espaçamento entre o título e o nome
                Text(
                  '${user.nome} ${user.sobrenome}', // Exibe o nome e sobrenome
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person), // Ícone do perfil
            title: const Text('Perfil'),
            onTap: () {
              // Ação ao clicar em "Perfil"
              Navigator.pop(context); // Fecha o menu
              Navigator.of(context)
                  .pushNamed('/perfil'); // Navega para a página de perfil
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout), // Ícone do botão de sair
            title: const Text('Sair'),
            onTap: () {
              // Ação ao clicar em "Sair"
              Navigator.pop(context); // Fecha o menu
              HomePage.signOutUser(context); // Navega de volta à tela de login
            },
          ),
        ],
      ),
    );
  }
}
