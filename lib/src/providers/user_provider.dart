import 'package:flutter/material.dart';
import 'package:tfc_fitguide/src/models/user_model.dart';
import 'package:tfc_fitguide/src/services/auth_service.dart';
import 'package:tfc_fitguide/src/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  // Cargamos los datos del usuario desde Firestore
  Future<void> loadUser() async {
    try {
      _isLoading = true;
      notifyListeners();

      final authService = AuthService();
      final currentUser = authService.currentUser;

      if (currentUser != null) {
        final userService = UserService();
        _user = await userService.getUser(currentUser.uid);
      }
    } catch (e) {
      debugPrint('Error cargando usuario: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
