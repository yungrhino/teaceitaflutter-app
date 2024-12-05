import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teaceita/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Perfilpage extends StatefulWidget {
  const Perfilpage({super.key});

  @override
  State<Perfilpage> createState() => _PerfilpageState();
}

class _PerfilpageState extends State<Perfilpage> {
  File? _image;
  final _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null || _descriptionController.text.isEmpty) {
      print('Por favor, selecione uma imagem e insira uma descrição.');
      return;
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://15.229.250.5:4000/pictures/'));
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
    request.fields['description'] = _descriptionController.text;

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print('Imagem enviada com sucesso: $responseString');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imagem enviada com sucesso!')),
        );
        setState(() {
          _image = null;
          _descriptionController.clear();
        });
      } else {
        print('Erro ao enviar imagem: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${user.nome} ${user.sobrenome}',
                style: const TextStyle(fontSize: 18)),
            Text(user.email, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Selecionar Imagem'),
            ),
            _image != null
                ? Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : const Text('Nenhuma imagem selecionada'),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Enviar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Voltar para Home'),
            ),
          ],
        ),
      ),
    );
  }
}
