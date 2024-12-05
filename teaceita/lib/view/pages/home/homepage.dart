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
          await http.get(Uri.parse('http://15.229.250.5:4000/pictures'));

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
        child: imageData.isEmpty
            ? const CircularProgressIndicator() // Mostra um indicador de carregamento
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: imageData.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          child: Image.network(
                            imageData[index]['src']!,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit
                                .cover, // Garante que a imagem se ajuste ao espaço disponível
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      imageData[index]['description']!,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Descrição da imagem ou outro texto aqui',
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.grey),
                              ),
                            ],
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

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${user.nome} ${user.sobrenome}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Locais'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/perfil');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pop(context);
              HomePage.signOutUser(context);
            },
          ),
        ],
      ),
    );
  }
}
