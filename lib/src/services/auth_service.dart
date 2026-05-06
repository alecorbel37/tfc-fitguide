import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges =>
      _auth.authStateChanges(); // Para escuchar los cambios de la sesión

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'La contraseña es demasiado débil';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este correo';
      case 'user-not-found':
        return 'No existe ninguna cuenta con este correo';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'invalid-email':
        return 'El correo electrónico no es válido';
      case 'user-disabled':
        return 'Esta cuenta ha sido desactivada';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos, inténtalo más tarde';
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos';
      default:
        return 'Ha ocurrido un error, inténtalo de nuevo';
    }
  }
}
