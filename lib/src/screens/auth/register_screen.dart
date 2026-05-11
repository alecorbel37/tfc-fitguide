import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../models/user_model.dart';
import '../../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _alturaController = TextEditingController();
  final _pesoController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  int _currentStep = 1;
  String? _selectedObjetivo;
  bool _isSocialLogin = false;
  String? _socialUid;

  final List<String> _objetivos = [
    'Perder peso',
    'Ganar masa muscular',
    'Mejorar la salud',
    'Mantener el peso',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is firebase_auth.User && !_isSocialLogin) {
      _isSocialLogin = true;
      _socialUid = args.uid;
      _emailController.text = args.email ?? '';

      // Intentamos separar nombre y apellidos del displayName de Google
      final String displayName = args.displayName ?? '';
      if (displayName.isNotEmpty) {
        final parts = displayName.split(' ');
        _nombreController.text = parts[0];
        if (parts.length > 1) {
          _apellidosController.text = parts.sublist(1).join(' ');
        }
      }

      _currentStep = 2; // Saltamos directamente al paso de datos físicos
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _alturaController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      if (_currentStep == 1) {
        setState(() => _currentStep = 2);
      } else {
        _handleRegister();
      }
    }
  }

  void _handleRegister() async {
    setState(() => _isLoading = true);
    try {
      final authService = AuthService();
      String? uid = _socialUid;

      if (!_isSocialLogin) {
        final credential = await authService.register(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        uid = credential?.user?.uid;
      }

      if (uid != null) {
        final userService = UserService();
        final user = UserModel(
          uid: uid,
          nombre: _nombreController.text.trim(),
          apellidos: _apellidosController.text.trim(),
          email: _emailController.text.trim(),
          objetivo: _selectedObjetivo ?? '',
          altura: double.tryParse(_alturaController.text.trim()) ?? 0,
          peso: double.tryParse(_pesoController.text.trim()) ?? 0,
          createdAt: DateTime.now(),
        );
        await userService.saveUser(user);
      }

      if (mounted) {
        // Redirigimos al Login en lugar de al Home para que tenga que verificar el email
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  double _getPasswordStrength() {
    final password = _passwordController.text;
    if (password.isEmpty) return 0;
    double strength = 0;
    if (password.length >= 6) strength += 0.25;
    if (password.length >= 10) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9!@#\$%^&*]'))) strength += 0.25;
    return strength;
  }

  Color _getPasswordStrengthColor() {
    final strength = _getPasswordStrength();
    if (strength <= 0.25) return AppColors.error;
    if (strength <= 0.5) return AppColors.accent;
    if (strength <= 0.75) return Colors.yellow.shade700;
    return AppColors.success;
  }

  String _getPasswordStrengthLabel() {
    final strength = _getPasswordStrength();
    if (strength <= 0.25) return 'Contraseña débil';
    if (strength <= 0.5)
      return 'Seguridad media — añade símbolos para mejorarla';
    if (strength <= 0.75) return 'Contraseña buena';
    return 'Contraseña muy segura';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHero(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_currentStep == 1) ..._buildStep1(),
                    if (_currentStep == 2) ..._buildStep2(),
                    const SizedBox(height: 20),
                    _buildContinueButton(),
                    const SizedBox(height: 12),
                    _buildLoginLink(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_currentStep == 2) {
                      setState(() => _currentStep = 1);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Crear cuenta',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Empieza tu transformación hoy',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 14),
                _buildProgressBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          flex: 1,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: _currentStep == 2
                  ? AppColors.accent
                  : Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Paso $_currentStep de 2',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildStep1() {
    return [
      _buildSectionTitle('Datos personales'),
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            child: _buildField(
              label: 'Nombre',
              controller: _nombreController,
              hint: 'Nombre',
              validator: (v) => v!.isEmpty ? 'Obligatorio' : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildField(
              label: 'Apellidos',
              controller: _apellidosController,
              hint: 'Apellidos',
              validator: (v) => v!.isEmpty ? 'Obligatorio' : null,
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      _buildField(
        label: 'Correo electrónico',
        controller: _emailController,
        hint: 'ejemplo@correo.com',
        keyboardType: TextInputType.emailAddress,
        validator: (v) {
          if (v!.isEmpty) return 'Introduce tu correo';
          if (!v.contains('@')) return 'Correo no válido';
          return null;
        },
      ),
      const SizedBox(height: 14),
      _buildPasswordField(),
    ];
  }

  List<Widget> _buildStep2() {
    return [
      _buildSectionTitle('Datos físicos'),
      const SizedBox(height: 14),
      _buildDropdown(),
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(
            child: _buildFieldWithUnit(
              label: 'Altura',
              controller: _alturaController,
              hint: '170',
              unit: 'cm',
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Obligatorio' : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildFieldWithUnit(
              label: 'Peso inicial',
              controller: _pesoController,
              hint: '65',
              unit: 'kg',
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Obligatorio' : null,
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(color: Color(0xFFE5E7EB), height: 1),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(hintText: hint),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildFieldWithUnit({
    required String label,
    required TextEditingController controller,
    required String hint,
    required String unit,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            suffixText: unit,
            suffixStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: AppColors.textHint,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contraseña',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: '••••••••',
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Text(
                  _obscurePassword ? 'Ver' : 'Ocultar',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 60,
              minHeight: 48,
            ),
          ),
          validator: (v) {
            if (v!.isEmpty) return 'Introduce tu contraseña';
            if (v.length < 6) return 'Mínimo 6 caracteres';
            return null;
          },
        ),
        if (_passwordController.text.isNotEmpty) ...[
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: _getPasswordStrength(),
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getPasswordStrengthColor(),
              ),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getPasswordStrengthLabel(),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: _getPasswordStrengthColor(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Objetivo fitness',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: _selectedObjetivo,
          hint: const Text(
            'Selecciona un objetivo',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: AppColors.textHint,
            ),
          ),
          decoration: const InputDecoration(),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
          items: _objetivos.map((objetivo) {
            return DropdownMenuItem(value: objetivo, child: Text(objetivo));
          }).toList(),
          onChanged: (value) => setState(() => _selectedObjetivo = value),
          validator: (v) => v == null ? 'Selecciona un objetivo' : null,
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleContinue,
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(_currentStep == 1 ? 'Continuar' : 'Crear cuenta'),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
        child: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            children: [
              TextSpan(text: '¿Ya tienes cuenta? '),
              TextSpan(
                text: 'Inicia sesión',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
