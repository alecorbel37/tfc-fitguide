import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../routes/app_routes.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.dividerColor, width: 1),
        ),
      ),
      child: SafeArea( // Para evitar que la barra quede tapada por la barra de gestos de Android
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.home_rounded,
                label: 'Inicio',
                route: AppRoutes.home,
              ),
              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.restaurant_menu_rounded,
                label: 'Nutrición',
                route: AppRoutes.nutrition,
              ),
              _buildNavItem(
                context: context,
                index: 2,
                icon: Icons.fitness_center_rounded,
                label: 'Entreno',
                route: AppRoutes.training,
              ),
              _buildNavItem(
                context: context,
                index: 3,
                icon: Icons.chat_rounded,
                label: 'Chat',
                route: AppRoutes.chat,
              ),
              _buildNavItem(
                context: context,
                index: 4,
                icon: Icons.person_rounded,
                label: 'Perfil',
                route: AppRoutes.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    required String route,
  }) {
    final theme = Theme.of(context);
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? AppColors.primary : theme.hintColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? AppColors.primary : theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
