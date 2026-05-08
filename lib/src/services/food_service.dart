import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_model.dart';

class FoodService {
  static const String _baseUrl = 'https://world.openfoodfacts.org/cgi/search.pl';

  Future<List<FoodModel>> searchFoods(String query) async {
    if (query.isEmpty) return [];

    try {
      final uri = Uri.parse(_baseUrl).replace(queryParameters: {
        'search_terms': query,
        'search_simple': '1',
        'action': 'process',
        'json': '1',
        'page_size': '20',
        'lc': 'es',
        'fields': 'product_name,product_name_es,nutriments,_id',
      });

      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final products = data['products'] as List<dynamic>? ?? [];

        return products
            .map((p) => FoodModel.fromOpenFoodFacts(
                p as Map<String, dynamic>))
            .where((f) =>
                f.name != 'Producto sin nombre' && f.calories > 0)
            .toList();
      }
      return [];
    } catch (e) {
      throw 'Error al buscar alimentos. Comprueba tu conexión.';
    }
  }
}