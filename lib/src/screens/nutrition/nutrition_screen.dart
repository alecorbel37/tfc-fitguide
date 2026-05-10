import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/app_colors.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../models/food_model.dart';
import '../../models/meal_log_model.dart';
import '../../services/nutrition_service.dart';
import '../../routes/app_routes.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  DateTime _selectedDate = DateTime.now();
  List<MealLogModel> _mealLogs = [];
  bool _isLoading = false;
  final NutritionService _nutritionService = NutritionService();

  final List<Map<String, dynamic>> _mealTypes = [
    {
      'title': 'Desayuno',
      'icon': Icons.wb_sunny_rounded,
      'iconColor': AppColors.accent,
    },
    {
      'title': 'Almuerzo',
      'icon': Icons.lunch_dining_rounded,
      'iconColor': AppColors.primary,
    },
    {
      'title': 'Cena',
      'icon': Icons.nightlight_round,
      'iconColor': AppColors.primary,
    },
    {
      'title': 'Snacks',
      'icon': Icons.cookie_rounded,
      'iconColor': AppColors.accent,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadMealLogs();
  }

  Future<void> _loadMealLogs() async {
    setState(() => _isLoading = true);
    try {
      final logs = await _nutritionService.getMealLogs(_selectedDate);
      setState(() {
        _mealLogs = logs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
    _loadMealLogs();
  }

  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
    _loadMealLogs();
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

  List<MealLogModel> _getLogsForMeal(String mealType) {
    return _mealLogs.where((log) => log.mealType == mealType).toList();
  }

  double get _totalCalories =>
      _mealLogs.fold(0, (sum, log) => sum + log.calories);

  double get _totalProtein =>
      _mealLogs.fold(0, (sum, log) => sum + log.protein);

  double get _totalCarbs => _mealLogs.fold(0, (sum, log) => sum + log.carbs);

  Color _getIconBg(Color iconColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (iconColor == AppColors.accent) {
      return isDark ? AppColors.accent.withValues(alpha: 0.15) : AppColors.iconBgOrange;
    }
    return isDark ? AppColors.primary.withValues(alpha: 0.15) : AppColors.iconBgGreen;
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
      body: Column(
        children: [
          _buildHero(),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      children: _mealTypes.map((meal) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildMealCard(
                            title: meal['title'] as String,
                            icon: meal['icon'] as IconData,
                            iconColor: meal['iconColor'] as Color,
                            iconBg: _getIconBg(meal['iconColor'] as Color),
                            items: _getLogsForMeal(meal['title'] as String),
                          ),
                        );
                      }).toList(),
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
          _buildMacroCol(
            _totalCalories.toStringAsFixed(0),
            'Consumidas',
            'kcal',
          ),
          _buildMacroDivider(),
          _buildMacroCol(
            (2100 - _totalCalories).toStringAsFixed(0),
            'Restantes',
            'kcal',
          ),
          _buildMacroDivider(),
          _buildMacroCol(
            '${_totalProtein.toStringAsFixed(0)}g',
            'Proteína',
            '/ 150g',
          ),
          _buildMacroDivider(),
          _buildMacroCol(
            '${_totalCarbs.toStringAsFixed(0)}g',
            'Carbos',
            '/ 220g',
          ),
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
    required List<MealLogModel> items,
  }) {
    final theme = Theme.of(context);
    final mealCalories = items.fold(0.0, (sum, log) => sum + log.calories);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          _buildMealHeader(
            title: title,
            icon: icon,
            iconColor: iconColor,
            iconBg: iconBg,
            kcal: mealCalories,
          ),
          if (items.isNotEmpty) ...items.map((item) => _buildFoodItem(item)),
        ],
      ),
    );
  }

  Widget _buildMealHeader({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required double kcal,
  }) {
    final theme = Theme.of(context);

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
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  kcal > 0
                      ? '${kcal.toStringAsFixed(0)} kcal'
                      : 'Sin registrar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: kcal > 0
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.hintColor,
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
              if (result != null && mounted) {
                final food = result as FoodModel;
                try {
                  await _nutritionService.addMealLog(
                    food: food,
                    mealType: title,
                    date: _selectedDate,
                  );
                  await _loadMealLogs();
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: AppColors.error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                }
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

  Widget _buildFoodItem(MealLogModel item) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.foodName,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.quantity.toStringAsFixed(0)}g · ${item.protein.toStringAsFixed(1)}g prot · ${item.carbs.toStringAsFixed(1)}g carbos',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${item.calories.toStringAsFixed(0)} kcal',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () async {
              await _nutritionService.deleteMealLog(item.id);
              await _loadMealLogs();
            },
            child: Icon(
              Icons.close_rounded,
              color: theme.hintColor,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
