import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Opción correcta para deshabilitar reCAPTCHA en pruebas sin usar emuladores
  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: true,
  );
  
  runApp(const SOSAApp());
}