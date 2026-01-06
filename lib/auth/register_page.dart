import 'package:flutter/material.dart';
import '../home/home_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro SOSA')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _field('Nombre completo'),
            _field('Cédula'),
            _field('Celular'),
            _field('Correo Gmail'),
            _field('Edad'),
            _dropdown(),
            _field('Dirección'),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage(isGuest: false)),
                );
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _dropdown() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Sexo',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: const [
        DropdownMenuItem(value: 'M', child: Text('Masculino')),
        DropdownMenuItem(value: 'F', child: Text('Femenino')),
        DropdownMenuItem(value: 'O', child: Text('Otro')),
      ],
      onChanged: (_) {},
    );
  }
}
