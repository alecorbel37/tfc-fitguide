import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal_log_model.dart';
import '../models/food_model.dart';
import 'auth_service.dart';

class NutritionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'meal_logs';

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> addMealLog({
    required FoodModel food,
    required String mealType,
    required DateTime date,
  }) async {
    try {
      final authService = AuthService();
      final userId = authService.currentUser?.uid;
      if (userId == null) throw 'Usuario no autenticado';

      final docRef = _firestore.collection(_collection).doc();

      final log = MealLogModel(
        id: docRef.id,
        userId: userId,
        mealType: mealType,
        foodName: food.name,
        calories: food.calories,
        protein: food.protein,
        carbs: food.carbs,
        fat: food.fat,
        quantity: double.tryParse(food.servingSize.replaceAll('g', '')) ?? 100,
        date: date,
      );

      await docRef.set(log.toMap());
    } catch (e) {
      throw 'Error al guardar el alimento';
    }
  }

  // Obtenemos los alimentos de un día
  Future<List<MealLogModel>> getMealLogs(DateTime date) async {
    try {
      final authService = AuthService();
      final userId = authService.currentUser?.uid;
      if (userId == null) return [];

      final dateKey = _dateKey(date);

      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => MealLogModel.fromMap(doc.data()))
          .where((log) => _dateKey(log.date) == dateKey)
          .toList();
    } catch (e) {
      throw 'Error al obtener los alimentos';
    }
  }

  Future<void> deleteMealLog(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw 'Error al eliminar el alimento';
    }
  }
}
