import 'package:flutter/material.dart';
import '../auth/register_page.dart';

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
        if (isGuest) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Alerta "$title" enviada')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
