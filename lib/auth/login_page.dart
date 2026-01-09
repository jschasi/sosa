import 'package:flutter/material.dart';
import '../home/home_page.dart';
import 'register_page.dart';
import '../auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override



  
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const Icon(Icons.security, size: 90, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    'ALERTIKA',
                    style: TextStyle(
                      fontSize: 36,
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
                              if (v.length < 4) return 'Contraseña muy corta';
                              return null;
                            },
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
                                        await AuthService().signIn(
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text.trim(),
                                        );
                                        if (!mounted) return;
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage(isGuest: false)));
                                      } catch (e) {
                                        print("ERROR LOGIN: $e");
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
                                      } finally {
                                        if (mounted) setState(() => _loading = false);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _loading
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('Iniciar sesión'),
                            ),
                          ),

                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: _loading
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const RegisterPage()),
                                        );
                                      },
                                child: const Text(
                                  'Registrarse',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),

                              TextButton(
                                onPressed: _loading
                                    ? null
                                    : () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (_) => const HomePage(isGuest: true)),
                                        );
                                      },
                                child: const Text(
                                  'Ingresar como invitado',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ],
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
