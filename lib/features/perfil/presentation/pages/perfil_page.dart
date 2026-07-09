import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/config/app_config.dart';
import '../../../../app/theme/app_colors.dart';
import '../../data/datasource/perfil_remote_datasource.dart';
import '../../data/models/perfil_model.dart';

class PerfilPage extends StatefulWidget {
  final String cedula;

  const PerfilPage({
    super.key,
    required this.cedula,
  });

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final PerfilRemoteDataSource dataSource = PerfilRemoteDataSource();

  PerfilModel? perfil;
  bool isLoading = true;
  bool isSaving = false;
  String error = '';

  final descripcionController = TextEditingController();
  final telefonoController = TextEditingController();
  final correoController = TextEditingController();

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _backgroundColor =>
      _isDark ? const Color(0xFF081B2E) : const Color.fromARGB(255, 220, 224, 228);

  Color get _cardColor => _isDark ? const Color(0xFF0F2A44) : Colors.white;

  Color get _titleColor => _isDark ? Colors.white : AppColors.happyBlueDark;

  Color get _subtitleColor =>
      _isDark ? Colors.white.withOpacity(0.65) : const Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    cargarPerfil();
  }

  @override
  void dispose() {
    descripcionController.dispose();
    telefonoController.dispose();
    correoController.dispose();
    super.dispose();
  }

  Future<void> cargarPerfil() async {
    try {
      final result = await dataSource.getPerfil(widget.cedula);

      if (!mounted) return;

      setState(() {
        perfil = result;
        descripcionController.text = result.descripcion;
        telefonoController.text = result.telefono;
        correoController.text = result.correo;
        isLoading = false;
        error = '';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  Future<void> guardarPerfil() async {
    if (perfil == null) return;

    setState(() {
      isSaving = true;
    });

    try {
      final mensaje = await dataSource.guardarPerfil(
        cedula: perfil!.cedula,
        descripcion: descripcionController.text.trim(),
        telefono: telefonoController.text.trim(),
        correo: correoController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );

      await cargarPerfil();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> seleccionarFoto() async {
    if (perfil == null) return;

    final picker = ImagePicker();

    final foto = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (foto == null) return;

    setState(() {
      isSaving = true;
    });

    try {
      await dataSource.subirFoto(
        cedula: perfil!.cedula,
        foto: foto,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto actualizada correctamente.'),
        ),
      );

      await cargarPerfil();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  String _fotoCompleta(String fotoUrl) {
    if (fotoUrl.trim().isEmpty) return '';

    if (fotoUrl.startsWith('http')) {
      return fotoUrl;
    }

    return '${AppConfig.serverBaseUrl}$fotoUrl';
  }

  String _iniciales(String nombre) {
    final partes = nombre.trim().split(' ').where((e) => e.isNotEmpty).toList();

    if (partes.isEmpty) return '??';

    if (partes.length == 1) {
      return partes.first.substring(0, 1).toUpperCase();
    }

    return (partes[0].substring(0, 1) + partes[1].substring(0, 1))
        .toUpperCase();
  }

  String _capitalizarNombre(String texto) {
    if (texto.trim().isEmpty) return texto;

    return texto
        .toLowerCase()
        .split(' ')
        .map((palabra) {
          if (palabra.isEmpty) return palabra;
          return palabra[0].toUpperCase() + palabra.substring(1);
        })
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _isDark ? const Color(0xFF0F2A44) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: _isDark ? Colors.white : AppColors.happyBlueDark,
        ),
        title: Text(
          'Mi Perfil',
          style: TextStyle(
            color: _titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.happyGreen,
              ),
            )
          : error.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      error,
                      style: TextStyle(
                        color: _titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  child: Column(
                    children: [
                      _perfilHeader(),
                      const SizedBox(height: 18),
                      _formularioPerfil(),
                    ],
                  ),
                ),
    );
  }

  Widget _perfilHeader() {
    final data = perfil!;
    final foto = _fotoCompleta(data.fotoUrl);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _isDark
              ? Colors.white.withOpacity(0.08)
              : AppColors.happyBlueDark,
          width: _isDark ? 1 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isDark ? 0.14 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: seleccionarFoto,
            child: Stack(
              children: [
                ClipOval(
                  child: Container(
                    width: 116,
                    height: 116,
                    color: _isDark
                        ? Colors.white.withOpacity(0.12)
                        : const Color(0xFFE0F2FE),
                    child: foto.isNotEmpty
                        ? Image.network(
                            foto,
                            width: 116,
                            height: 116,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _avatarIniciales(data.nombre);
                            },
                          )
                        : _avatarIniciales(data.nombre),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.happyGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isDark ? const Color(0xFF0F2A44) : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: AppColors.happyBlueDark,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _capitalizarNombre(data.nombre),
            style: TextStyle(
              color: _titleColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            data.tienda,
            style: TextStyle(
              color: _subtitleColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Toca la foto para cambiarla',
            style: TextStyle(
              color: AppColors.happyGreen,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarIniciales(String nombre) {
    return Center(
      child: Text(
        _iniciales(nombre),
        style: TextStyle(
          color: _isDark ? Colors.white : AppColors.happyBlueDark,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _formularioPerfil() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _isDark
              ? Colors.white.withOpacity(0.08)
              : AppColors.happyBlueDark,
          width: _isDark ? 1 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isDark ? 0.14 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información del perfil',
            style: TextStyle(
              color: _titleColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          _campoPerfil(
            label: 'Descripción',
            controller: descripcionController,
            icon: Icons.description_outlined,
            maxLines: 3,
          ),
          _campoPerfil(
            label: 'Teléfono',
            controller: telefonoController,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          _campoPerfil(
            label: 'Correo',
            controller: correoController,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isSaving ? null : guardarPerfil,
              icon: isSaving
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                isSaving ? 'Guardando...' : 'Guardar Perfil',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.happyGreen,
                foregroundColor: AppColors.happyBlueDark,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoPerfil({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(
          color: _titleColor,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: AppColors.happyGreen,
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: _subtitleColor,
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: _isDark ? const Color(0xFF081B2E) : const Color(0xFFF8FAFC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: _isDark
                  ? Colors.white.withOpacity(0.08)
                  : AppColors.happyBlueDark.withOpacity(0.45),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.happyGreen,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}