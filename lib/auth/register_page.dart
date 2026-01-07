import 'package:flutter/material.dart';
import '../home/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _gender;
  bool _loading = false;
  bool _accepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF0A74DA), // fondo de un solo color
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagen/encabezado al tope
              Center(
                child: Column(
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80&auto=format&fit=crop',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 12),
                    const Text('Crea tu cuenta', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 18),
                  ],
                ),
              ),

              _buildTextField(_nameController, 'Nombre completo', labelColor: Colors.white, validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese su nombre' : null),
              _buildTextField(_idController, 'Cédula', keyboard: TextInputType.number, labelColor: Colors.white, validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese su cédula' : null),
              _buildTextField(_phoneController, 'Celular', keyboard: TextInputType.phone, labelColor: Colors.white, validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese su celular' : null),
              _buildTextField(_emailController, 'Correo', keyboard: TextInputType.emailAddress, labelColor: Colors.white, validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Ingrese el correo';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return 'Correo inválido';
                return null;
              }),

              Row(
                children: [
                  Expanded(child: _buildTextField(_ageController, 'Edad', keyboard: TextInputType.number, labelColor: Colors.white, validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Ingrese la edad';
                    final n = int.tryParse(v);
                    if (n == null || n <= 0) return 'Edad inválida';
                    return null;
                  })),
                  const SizedBox(width: 12),
                  Expanded(child: _genderDropdown()),
                ],
              ),

              _buildTextField(_addressController, 'Dirección', labelColor: Colors.white, validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese la dirección' : null),

              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(value: _accepted, onChanged: (v) => setState(() => _accepted = v ?? false), activeColor: Colors.white),
                  const Expanded(child: Text('Acepto los términos y condiciones', style: TextStyle(color: Colors.white70))),
                ],
              ),

              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: (!_accepted || _loading)
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() => _loading = true);
                          await Future.delayed(const Duration(milliseconds: 800));
                          if (!mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage(isGuest: false)),
                          );
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Registrarse'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, {TextInputType keyboard = TextInputType.text, String? Function(String?)? validator, Color labelColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: labelColor),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white54)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        validator: validator,
      ),
    );
  }

  Widget _genderDropdown() {
    return DropdownButtonFormField<String>(
      value: _gender,
      decoration: InputDecoration(
        labelText: 'Sexo',
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white54)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white)),
      ),
      items: const [
        DropdownMenuItem(value: 'M', child: Text('Masculino')),
        DropdownMenuItem(value: 'F', child: Text('Femenino')),
        DropdownMenuItem(value: 'O', child: Text('Otro')),
      ],
      onChanged: (v) => setState(() => _gender = v),
      validator: (v) => v == null || v.isEmpty ? 'Seleccione sexo' : null,
    );
  }
}
