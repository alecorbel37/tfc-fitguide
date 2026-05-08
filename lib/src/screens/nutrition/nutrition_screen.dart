import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfc_fitguide/src/widgets/bottom_nav_bar.dart';
import '../../../constants/app_colors.dart';
import '../../models/food_model.dart';
import '../../routes/app_routes.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  DateTime _selectedDate = DateTime.now();

  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);

    if (selected == today) return 'Hoy';
    if (selected == today.subtract(const Duration(days: 1))) return 'Ayer';

    final months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final days = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];

    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];
    return '$dayName, ${date.day} de $monthName';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHero(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                children: [
                  _buildMealCard(
                    title: 'Desayuno',
                    icon: Icons.wb_sunny_rounded,
                    iconColor: AppColors.accent,
                    iconBg: AppColors.iconBgOrange,
                    kcal: 480,
                    items: [
                      {
                        'name': 'Avena con frutas',
                        'info': '100g · 12g prot · 58g carbs',
                        'kcal': 320,
                      },
                      {
                        'name': 'Leche semidesnatada',
                        'info': '200ml · 6g prot · 10g carbs',
                        'kcal': 160,
                      },
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildMealCard(
                    title: 'Almuerzo',
                    icon: Icons.lunch_dining_rounded,
                    iconColor: AppColors.primary,
                    iconBg: AppColors.iconBgGreen,
                    kcal: 620,
                    items: [
                      {
                        'name': 'Pechuga de pollo',
                        'info': '150g · 46g prot · 0g carbos',
                        'kcal': 248,
                      },
                      {
                        'name': 'Arroz blanco cocido',
                        'info': '180g · 5g prot · 52g carbos',
                        'kcal': 234,
                      },
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildMealCard(
                    title: 'Cena',
                    icon: Icons.nightlight_round,
                    iconColor: AppColors.primary,
                    iconBg: AppColors.iconBgGreen,
                    kcal: 0,
                    items: const [],
                  ),
                  const SizedBox(height: 10),
                  _buildMealCard(
                    title: 'Snacks',
                    icon: Icons.cookie_rounded,
                    iconColor: AppColors.accent,
                    iconBg: AppColors.iconBgOrange,
                    kcal: 0,
                    items: const [],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                children: [
                  _buildHeroTop(),
                  const SizedBox(height: 16),
                  _buildMacroSummary(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nutrición',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _formatDate(_selectedDate),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildDateArrow(Icons.chevron_left_rounded, _previousDay),
            const SizedBox(width: 8),
            _buildDateArrow(Icons.chevron_right_rounded, _nextDay),
          ],
        ),
      ],
    );
  }

  Widget _buildDateArrow(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildMacroSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMacroCol('1.450', 'Consumidas', 'kcal'),
          _buildMacroDivider(),
          _buildMacroCol('760', 'Restantes', 'kcal'),
          _buildMacroDivider(),
          _buildMacroCol('120g', 'Proteína', '/ 150g'),
          _buildMacroDivider(),
          _buildMacroCol('180g', 'Carbos', '/ 220g'),
        ],
      ),
    );
  }

  Widget _buildMacroCol(String value, String label, String sub) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        Text(
          sub,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMacroDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.15),
    );
  }

  Widget _buildMealCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required int kcal,
    required List<Map<String, dynamic>> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildMealHeader(title, icon, iconColor, iconBg, kcal),
          if (items.isNotEmpty) ...items.map((item) => _buildFoodItem(item)),
        ],
      ),
    );
  }

  Widget _buildMealHeader(
    String title,
    IconData icon,
    Color iconColor,
    Color iconBg,
    int kcal,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  kcal > 0 ? '$kcal kcal' : 'Sin registrar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: kcal > 0
                        ? AppColors.textSecondary
                        : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.pushNamed(
                context,
                AppRoutes.addFood,
                arguments: title,
              );
              if (result != null) {
                // Aquí añadiremos el alimento a Firestore
                debugPrint('Alimento añadido: ${(result as FoodModel).name}');
              }
            },
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item['info'] as String,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${item['kcal']} kcal',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
