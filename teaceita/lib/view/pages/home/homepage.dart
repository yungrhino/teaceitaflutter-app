import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teaceita/models/user.dart';
import 'package:teaceita/providers/user_provider.dart';
import 'package:teaceita/services/auth_services.dart';

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

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user; // Inicialize user

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu), // Ícone do menu hambúrguer
            onPressed: () {
              // Usando o contexto do Builder para abrir o Drawer
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: _buildDrawer(), // Adiciona o menu lateral
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Botão "Home"
              },
              child: const Text('Home'),
            ),
          ],
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
