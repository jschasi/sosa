import 'package:flutter/material.dart';
import 'alert_button.dart';
import '../core/colors.dart';
import '../link/link_page.dart'; // 👈 IMPORTANTE

class HomePage extends StatelessWidget {
  final bool isGuest;
  const HomePage({super.key, required this.isGuest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Alarmas')),
      drawer: _drawer(context),
      body: GridView.count(
        padding: const EdgeInsets.all(12),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          AlertButton('Pánico', Icons.warning, AppColors.panic, isGuest),
          AlertButton('Incendio', Icons.local_fire_department, AppColors.fire, isGuest),
          AlertButton('Asistencia', Icons.person, AppColors.assist, isGuest),
          AlertButton('En Camino', Icons.timer, AppColors.onWay, isGuest),
          AlertButton('Estoy Aquí', Icons.location_on, AppColors.here, isGuest),
        ],
      ),
    );
  }

  Drawer _drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                'SOSA',
                style: TextStyle(fontSize: 28),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () => Navigator.pop(context),
          ),

          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Vincular'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LinkPage(isGuest: isGuest),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
