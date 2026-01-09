import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener usuario actual
  User? get currentUser => _auth.currentUser;

  // Stream para escuchar cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Iniciar sesión con Email y Contraseña
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Registrarse con Email, Contraseña y guardar datos adicionales
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String cedula,
    required String age,
    required String gender,
    required String address,
  }) async {
    try {
      // 1. Crear usuario en Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Guardar datos adicionales en Firestore
      if (userCredential.user != null) {
        try {
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'uid': userCredential.user!.uid,
            'email': email,
            'name': name,
            'phone': phone,
            'cedula': cedula,
            'age': age,
            'gender': gender,
            'address': address,
            'createdAt': FieldValue.serverTimestamp(),
            'role': 'user',
          });
        } catch (firebaseError) {
          // Si falla guardar en Firestore, eliminar el usuario de Auth
          await userCredential.user!.delete();
          throw Exception('Error guardando datos: $firebaseError');
        }
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Error en registro: $e');
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Manejo básico de errores
  String _handleAuthException(FirebaseAuthException e) {
    return e.message ?? 'Ocurrió un error desconocido';
  }
}