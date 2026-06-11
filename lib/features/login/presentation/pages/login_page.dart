import 'package:flutter/material.dart';

import '../../data/datasource/login_remote_datasource.dart';
import '../../../../app/app.dart';
import '../../../../app/theme/theme_toggle_switch.dart';
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
          backgroundColor: Colors.green,
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
          backgroundColor: Colors.red,
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

    final backgroundColor = isDark
        ? const Color(0xFF071B2D)
        : const Color(0xFFEFF4FA);

    final cardColor = isDark
        ? const Color(0xFF0F2A44)
        : Colors.white;

    final inputColor = isDark
        ? const Color(0xFF081B2E)
        : const Color(0xFFF1F5F9);

    final titleColor = isDark
        ? Colors.white
        : const Color(0xFF0F172A);

    final subtitleColor = isDark
        ? Colors.white.withOpacity(0.70)
        : const Color(0xFF64748B);

    final helperColor = isDark
        ? const Color(0xFFBFCF03)
        : const Color(0xFF6B7800);

    final inputTextColor = isDark
        ? Colors.white
        : const Color(0xFF0F172A);

    final inputLabelColor = isDark
        ? Colors.white.withOpacity(0.70)
        : const Color(0xFF64748B);

    final iconColor = isDark
        ? Colors.white.withOpacity(0.70)
        : const Color(0xFF64748B);

    const buttonColor = Color(0xFFBFCF03);

    final buttonTextColor = isDark
        ? const Color(0xFF19375F)
        : const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Form(
                  key: _formKey,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 430,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.10)
                              : Colors.black.withOpacity(0.07),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              isDark ? 0.28 : 0.12,
                            ),
                            blurRadius: 28,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedLoginHeader(isDark: isDark),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                18,
                                24,
                                26,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Bienvenido de nuevo',
                                    style: TextStyle(
                                      color: titleColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    'Ingresa con tus credenciales de la Academia Happy',
                                    style: TextStyle(
                                      color: helperColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 26),

                                  TextFormField(
                                    controller: _cedulaController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: inputTextColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Cédula',
                                      hintText: 'Ingresa tu cédula',
                                      hintStyle: TextStyle(
                                        color: inputLabelColor.withOpacity(0.72),
                                      ),
                                      labelStyle: TextStyle(
                                        color: inputLabelColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.badge_outlined,
                                        color: iconColor,
                                      ),
                                      filled: true,
                                      fillColor: inputColor,
                                      errorStyle: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide(
                                          color: isDark
                                              ? Colors.white.withOpacity(0.05)
                                              : Colors.black.withOpacity(0.04),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide(
                                          color: isDark
                                              ? const Color(0xFF38BDF8)
                                              : const Color(0xFF0284C7),
                                          width: 1.5,
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

                                  const SizedBox(height: 16),

                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    style: TextStyle(
                                      color: inputTextColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Contraseña',
                                      hintText: 'Ingresa tu contraseña',
                                      hintStyle: TextStyle(
                                        color: inputLabelColor.withOpacity(0.72),
                                      ),
                                      labelStyle: TextStyle(
                                        color: inputLabelColor,
                                        fontWeight: FontWeight.w600,
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
                                        fontWeight: FontWeight.w600,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide(
                                          color: isDark
                                              ? Colors.white.withOpacity(0.05)
                                              : Colors.black.withOpacity(0.04),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide(
                                          color: isDark
                                              ? const Color(0xFF38BDF8)
                                              : const Color(0xFF0284C7),
                                          width: 1.5,
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

                                  const SizedBox(height: 24),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 54,
                                    child: ElevatedButton(
                                      onPressed:
                                          _isLoading ? null : _iniciarSesion,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: buttonColor,
                                        foregroundColor: buttonTextColor,
                                        disabledBackgroundColor:
                                            buttonColor.withOpacity(0.55),
                                        elevation: isDark ? 0 : 3,
                                        shadowColor:
                                            buttonColor.withOpacity(0.35),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.4,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'Ingresar',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  Text(
                                    'Happy - IronSeller',
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