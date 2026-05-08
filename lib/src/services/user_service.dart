import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'usuarios';

  // Guardar usuario en Firestore
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(user.uid)
          .set(user.toMap());
    } catch (e) {
      throw 'Error al guardar los datos del usuario';
    }
  }

  // Obtenemos el usuario por uid (userId)
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _firestore
          .collection(_collection)
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Error al obtener los datos del usuario';
    }
  }

  // Actualizamos los datos del usuario
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(uid)
          .update(data);
    } catch (e) {
      throw 'Error al actualizar los datos del usuario';
    }
  }
}