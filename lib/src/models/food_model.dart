class FoodModel {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String servingSize;

  FoodModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.servingSize,
  });

  factory FoodModel.fromOpenFoodFacts(Map<String, dynamic> product) {
    final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};

    return FoodModel(
      id: product['_id'] as String? ?? '',
      name: product['product_name'] as String? ??
          product['product_name_es'] as String? ??
          'Producto sin nombre',
      calories: (nutriments['energy-kcal_100g'] as num?)?.toDouble() ?? 0,
      protein: (nutriments['proteins_100g'] as num?)?.toDouble() ?? 0,
      carbs: (nutriments['carbohydrates_100g'] as num?)?.toDouble() ?? 0,
      fat: (nutriments['fat_100g'] as num?)?.toDouble() ?? 0,
      servingSize: '100g',
    );
  }

  // Calcular valores según cantidad
  FoodModel withQuantity(double grams) {
    final factor = grams / 100;
    return FoodModel(
      id: id,
      name: name,
      calories: calories * factor,
      protein: protein * factor,
      carbs: carbs * factor,
      fat: fat * factor,
      servingSize: '${grams.toStringAsFixed(0)}g',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'servingSize': servingSize,
    };
  }
}