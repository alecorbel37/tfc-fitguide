import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  Stream<User?> get authStateChanges =>
      _auth.authStateChanges(); // Para escuchar los cambios de la sesión

  User? get currentUser => _auth.currentUser;

  Future<void> reloadUser() async { // Comprobamos si el email está verificado
    await _auth.currentUser?.reload();
  }

  Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  Future<UserCredential?> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.sendEmailVerification(); // Para verificar email
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

  // Acceso con Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Ha ocurrido un error con Google Sign-In: $e';
    }
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
