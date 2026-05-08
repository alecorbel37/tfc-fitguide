class MealLogModel {
  final String id;
  final String userId;
  final String mealType;
  final String foodName;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double quantity;
  final DateTime date;

  MealLogModel({
    required this.id,
    required this.userId,
    required this.mealType,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.quantity,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'mealType': mealType,
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'quantity': quantity,
      'date': date.toIso8601String(),
    };
  }

  factory MealLogModel.fromMap(Map<String, dynamic> map) {
    return MealLogModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      mealType: map['mealType'] as String,
      foodName: map['foodName'] as String,
      calories: (map['calories'] as num).toDouble(),
      protein: (map['protein'] as num).toDouble(),
      carbs: (map['carbs'] as num).toDouble(),
      fat: (map['fat'] as num).toDouble(),
      quantity: (map['quantity'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
    );
  }
}
