import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teaceita/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Perfilpage extends StatefulWidget {
  const Perfilpage({super.key});

  @override
  State<Perfilpage> createState() => _PerfilpageState();
}

class _PerfilpageState extends State<Perfilpage> {
  File? _image;
  final _descriptionController = TextEditingController();
  final Logger _logger = Logger();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null || _descriptionController.text.isEmpty) {
      return;
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.1.106:4000/pictures/'));
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
    request.fields['description'] = _descriptionController.text;

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        _logger.i('Imagem enviada com sucesso: $responseString');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagem enviada com sucesso!')),
        );
        setState(() {
          _image = null;
          _descriptionController.clear();
        });
      } else {
        _logger.e('Erro ao enviar imagem: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Erro: $e');
    }
  }

  Widget buildLocationCard({
  required String title,
  required String description,
  IconData? icon,
  String? status,
  required Color cardColor1,
  required Color cardColor2,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 10.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    elevation: 4,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          child: Stack(
            children: [
              if (_image != null)
                Image.file(
                  _image!,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                )
              else
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cardColor1, cardColor2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 50,
                      color: Colors.white,
                    ),
                    onPressed: _pickImage,
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (icon != null)
                    Row(
                      children: [
                        Icon(
                          icon,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 8.0), // Espaço entre os ícones
                       const Icon(
                          Icons.whatshot, // Ícone do foguinho
                          color: Colors.orange, // Cor do foguinho
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                description,
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              if (status != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    status,
                    style: const TextStyle(
                        fontSize: 12.0, color: Colors.orange),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'TEAaceita',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,  // Centraliza o título "TEAaceita" na AppBar
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Adicionando título "Local" ao lado esquerdo
         const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Local',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          buildLocationCard(
            title: 'Blue Park',
            description: 'Melhor escolha de lazer por psicólogos verificados.',
            icon: Icons.check_circle,
            cardColor1: Colors.green.shade700,
            cardColor2: Colors.green.shade400,
          ),
          buildLocationCard(
            title: 'Mabu Thermas Grand Resort',
            description: 'Aguardando verificação.',
            status: 'Aguardando verificação...',
            cardColor1: Colors.grey.shade600,
            cardColor2: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
