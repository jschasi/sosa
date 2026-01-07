import 'package:flutter/material.dart';
import '../auth/register_page.dart';
import 'alert_panico.dart';
import 'alert_incendio.dart';

class AlertButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isGuest;

  const AlertButton(this.title, this.icon, this.color, this.isGuest, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Pánico SIEMPRE va a AlertPanicoPage, sin importar si es guest
        if (title == 'Pánico') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AlertPanicoPage(),
            ),
          );
        } else if (title == 'Incendio') {
          // Incendio va a AlertIncendioPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AlertIncendioPage(),
            ),
          );
        } else if (isGuest) {
          // Otras alarmas solo para invitados: ir a Registrarse
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterPage()),
          );
        } else {
          // Otras alarmas para usuarios registrados
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Alerta "$title" enviada')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
