import 'package:flutter/material.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/nutrition/nutrition_screen.dart';
import '../screens/training/training_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String nutrition = '/nutrition';
  static const String training = '/training';
  static const String chat = '/chat';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      welcome: (context) => const WelcomeScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      nutrition: (context) => const NutritionScreen(),
      training: (context) => const TrainingScreen(),
      chat: (context) => const ChatScreen(),
      profile: (context) => const ProfileScreen(),
    };
  }
}
