import 'package:flutter/material.dart';
import 'login_page.dart';
import '../auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  String _gender = 'Masculino';
  final List<String> _genders = ['Masculino', 'Femenino', 'Otro'];

  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _cedulaController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: const Color(0xFF1F3A5F),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1F3A5F), Color(0xFF2C3E50)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_add, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    'Crear Cuenta',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Card(
                    color: Colors.white.withOpacity(0.06),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            enabled: !_loading,
                            style: const TextStyle(color: Colors.white),
                            decoration: _input('Nombre completo'),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese su nombre' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _emailController,
                            enabled: !_loading,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white),
                            decoration: _input('Correo electrónico'),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Ingrese su correo';
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return 'Correo inválido';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            enabled: !_loading,
                            obscureText: _obscure,
                            style: const TextStyle(color: Colors.white),
                            decoration: _input('Contraseña').copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Ingrese la contraseña';
                              if (v.length < 6) return 'Mínimo 6 caracteres';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          
                          // Campo Cédula
                          TextFormField(
                            controller: _cedulaController,
                            enabled: !_loading,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: _input('Cédula / DNI'),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese su cédula' : null,
                          ),
                          const SizedBox(height: 12),

                          // Campo Teléfono
                          TextFormField(
                            controller: _phoneController,
                            enabled: !_loading,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: Colors.white),
                            decoration: _input('Teléfono'),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese su teléfono' : null,
                          ),
                          const SizedBox(height: 12),

                          // Fila para Edad y Género
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _ageController,
                                  enabled: !_loading,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _input('Edad'),
                                  validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _gender,
                                  dropdownColor: const Color(0xFF2C3E50),
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _input('Género'),
                                  items: _genders.map((g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(g),
                                  )).toList(),
                                  onChanged: _loading ? null : (v) => setState(() => _gender = v!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Campo Dirección
                          TextFormField(
                            controller: _addressController,
                            enabled: !_loading,
                            style: const TextStyle(color: Colors.white),
                            decoration: _input('Dirección'),
                            validator: (v) => v == null || v.trim().isEmpty ? 'Ingrese su dirección' : null,
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _loading
                                  ? null
                                  : () async {
                                      if (!_formKey.currentState!.validate()) return;
                                      setState(() => _loading = true);

                                      try {
                                        await AuthService().signUp(
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text.trim(),
                                          name: _nameController.text.trim(),
                                          phone: _phoneController.text.trim(),
                                          cedula: _cedulaController.text.trim(),
                                          age: _ageController.text.trim(),
                                          gender: _gender,
                                          address: _addressController.text.trim(),
                                        );

                                        if (!mounted) return;

                                        // Diálogo de éxito en el centro
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (ctx) => Center(
                                            child: AlertDialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                              backgroundColor: Colors.white,
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.green,
                                                    ),
                                                    child: const Icon(Icons.check, color: Colors.white, size: 40),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  const Text(
                                                    '¡Usuario Registrado\ncon Éxito!',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  const Text(
                                                    'Ahora puedes iniciar sesión',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 45,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(ctx);
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(builder: (_) => const LoginPage()),
                                                        );
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.green,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                      ),
                                                      child: const Text('Ir a Iniciar Sesión', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        setState(() => _loading = false);
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red, duration: const Duration(seconds: 3)),
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _loading
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Registrarse'),
                            ),
                          ),

                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _loading ? null : () => Navigator.pop(context),
                            child: const Text(
                              '¿Ya tienes cuenta? Inicia sesión',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static InputDecoration _input(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      filled: true,
      fillColor: Colors.white.withOpacity(0.04),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}
