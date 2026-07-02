import 'package:flutter/material.dart';

import '../../data/datasource/login_remote_datasource.dart';
import '../../../../app/app.dart';
import '../../../../app/theme/theme_toggle_switch.dart';
import '../../../../app/theme/app_colors.dart';
import '../widgets/animated_login_header.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final LoginRemoteDataSource _dataSource = LoginRemoteDataSource();

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dataSource.login(
        cedula: _cedulaController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.mensaje),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainLayout(
            cedula: response.cedula,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight;

    final panelColor =
        isDark ? AppColors.cardDark : AppColors.cardLight;

    final inputColor =
        isDark ? const Color(0xFF081B2E) : const Color(0xFFF1F5F9);

    final titleColor =
        isDark ? AppColors.textDark : AppColors.textLight;

    final subtitleColor =
        isDark ? AppColors.mutedDark : AppColors.mutedLight;

    final inputTextColor =
        isDark ? AppColors.textDark : AppColors.textLight;

    final inputLabelColor =
        isDark ? AppColors.mutedDark : AppColors.mutedLight;

    final iconColor =
        isDark ? AppColors.mutedDark : AppColors.mutedLight;

    final borderColor =
        isDark ? AppColors.borderDark : AppColors.borderLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 430,
                ),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: panelColor,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          AnimatedLoginHeader(isDark: isDark),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(26, 28, 26, 34),
                            child: Column(
                              children: [
                                Text(
                                  'Bienvenido de nuevo',
                                  style: TextStyle(
                                    color: titleColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  'Ingresa con tus credenciales de la Academia Happy',
                                  style: TextStyle(
                                    color: AppColors.happyGreen,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 30),

                                TextFormField(
                                  controller: _cedulaController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    color: inputTextColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Cédula',
                                    hintText: 'Ingresa tu cédula',
                                    hintStyle: TextStyle(
                                      color: inputLabelColor.withOpacity(0.70),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    labelStyle: TextStyle(
                                      color: inputLabelColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.badge_outlined,
                                      color: iconColor,
                                    ),
                                    filled: true,
                                    fillColor: inputColor,
                                    errorStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 18,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22),
                                      borderSide: BorderSide(
                                        color: borderColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22),
                                      borderSide: const BorderSide(
                                        color: AppColors.happyGreen,
                                        width: 1.8,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22),
                                      borderSide: const BorderSide(
                                        color: AppColors.error,
                                        width: 1.4,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22),
                                      borderSide: const BorderSide(
                                        color: AppColors.error,
                                        width: 1.6,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Ingresa la cédula';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style: TextStyle(
                                    color: inputTextColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    hintText: 'Ingresa tu contraseña',
                                    hintStyle: TextStyle(
                                      color: inputLabelColor.withOpacity(0.70),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    labelStyle: TextStyle(
                                      color: inputLabelColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: iconColor,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: iconColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword =
                                              !_obscurePassword;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    fillColor: inputColor,
                                    errorStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 18,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22),
                                      borderSide: BorderSide(
                                        color: borderColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22),
                                      borderSide: const BorderSide(
                                        color: AppColors.happyGreen,
                                        width: 1.8,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22),
                                      borderSide: const BorderSide(
                                        color: AppColors.error,
                                        width: 1.4,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22),
                                      borderSide: const BorderSide(
                                        color: AppColors.error,
                                        width: 1.6,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Ingresa la contraseña';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 28),

                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed:
                                        _isLoading ? null : _iniciarSesion,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.happyGreen,
                                      foregroundColor: AppColors.happyBlue,
                                      disabledBackgroundColor:
                                          AppColors.happyGreen.withOpacity(0.55),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.4,
                                              color: AppColors.happyBlue,
                                            ),
                                          )
                                        : const Text(
                                            'Ingresar',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.06)
                                        : AppColors.happyBlueSoft,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Happy - IronSeller',
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.mutedDark
                                          : AppColors.happyBlue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                Text(
                                  'Plataforma comercial de vendedores Happy',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const Positioned(
              right: 18,
              top: 18,
              child: ThemeToggleSwitch(),
            ),
          ],
        ),
      ),
    );
  }
}