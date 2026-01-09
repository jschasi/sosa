import 'package:flutter/material.dart';
import 'alert_button.dart';
import '../core/colors.dart';
import '../link/link_page.dart';
import '../auth/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth_service.dart';

class HomePage extends StatefulWidget {
  final bool isGuest;
  const HomePage({super.key, required this.isGuest});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<String> _getUserName() async {
    try {
      final user = AuthService().currentUser;
      if (user == null) return 'Invitado';

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      return doc.exists ? (doc['name'] ?? 'Usuario') : 'Usuario';
    } catch (e) {
      return 'Usuario';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Alarmas', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: const Color(0xFF0A74DA),
      ),
      drawer: _drawer(context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A74DA), Color(0xFF0D47A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Encabezado de bienvenida
              ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
                ),
                child: Card(
                  color: Colors.white.withOpacity(0.12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.security, size: 48, color: Colors.white),
                        const SizedBox(height: 8),
                        FutureBuilder<String>(
                          future: _getUserName(),
                          builder: (context, snapshot) {
                            String greeting = widget.isGuest 
                              ? '¡Bienvenido Invitado!' 
                              : '¡Hola ${snapshot.data ?? 'Usuario'}!';
                            
                            return Text(
                              greeting,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sistema de Alertas de Seguridad',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Título de sección
              const Text(
                'Mis Alarmas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Grid de botones de alarma
              GridView.count(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  AlertButton('Pánico', Icons.warning, AppColors.panic, widget.isGuest),
                  AlertButton('Incendio', Icons.local_fire_department, AppColors.fire, widget.isGuest),
                  AlertButton('Robo', Icons.person, AppColors.assist, widget.isGuest),
                  AlertButton('En Camino', Icons.timer, AppColors.onWay, widget.isGuest),
                  AlertButton('Estoy Aquí', Icons.location_on, AppColors.here, widget.isGuest),
                ],
              ),

              const SizedBox(height: 20),

              // Sección de información
              Card(
                color: Colors.white.withOpacity(0.12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📋 Estado del Sistema',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statusWidget('Conectado', Colors.greenAccent),
                          _statusWidget('Activo', Colors.blueAccent),
                          _statusWidget(widget.isGuest ? 'Invitado' : 'Registrado', Colors.orangeAccent),
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
    );
  }

  Widget _statusWidget(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Drawer _drawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0D47A1),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A74DA), Color(0xFF0D47A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security, size: 56, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'SOSA',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sistema de Alertas',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          _drawerTile(
            context,
            icon: Icons.home,
            title: 'Inicio',
            onTap: () => Navigator.pop(context),
          ),

          _drawerTile(
            context,
            icon: Icons.link,
            title: 'Vincular',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LinkPage(isGuest: widget.isGuest),
                ),
              );
            },
          ),

          _drawerTile(
            context,
            icon: Icons.person,
            title: 'Perfil',
            onTap: () {},
          ),

          const Divider(color: Colors.white24, height: 24),

          _drawerTile(
            context,
            icon: Icons.logout,
            title: 'Cerrar sesión',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            isLogout: true,
          ),
        ],
      ),
    );
  }

  Widget _drawerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isLogout ? Colors.red.withOpacity(0.2) : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
