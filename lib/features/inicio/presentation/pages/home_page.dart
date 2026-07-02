import 'package:flutter/material.dart';
import '../../data/datasource/inicio_remote_datasource.dart';
import '../../../login/presentation/pages/login_page.dart';
import '../../data/models/inicio_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/config/app_config.dart';


class HomePage extends StatefulWidget {
  final String cedula;

  const HomePage({
    super.key,
    required this.cedula,
  });

  @override
  State<HomePage> createState() => _HomePageState();

}
String _fotoPerfilUrl(String fotoUrl) {
  if (fotoUrl.trim().isEmpty) return '';

  if (fotoUrl.startsWith('http')) {
    return fotoUrl;
  }

  return '${AppConfig.serverBaseUrl}$fotoUrl';
}

class _HomePageState extends State<HomePage> {
  final InicioRemoteDataSource dataSource = InicioRemoteDataSource();

  InicioModel? inicioData;
  bool isLoading = true;
  String error = '';

  String get cedulaActual => widget.cedula;

  @override
  void initState() {
    super.initState();
    cargarInicio();
  }

  Future<void> cargarInicio() async {
    try {
      final result = await dataSource.getInicio(cedulaActual);

      if (!mounted) return;

      setState(() {
        inicioData = result;
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

  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        return AlertDialog(
          backgroundColor:
              isDark ? const Color(0xFF0F2A44) : const Color(0xFFE5EAF0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            'Cerrar sesión',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Deseas salir y volver al login?',
            style: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.70)
                  : const Color(0xFF475569),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF38BDF8)
                      : const Color(0xFF0284C7),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF081B2E) : const Color.fromARGB(255, 220, 224, 228),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color:
                      isDark ? AppColors.happyGreen : const Color(0xFF0284C7),
                ),
              )
            : error.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        error,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    color: isDark
                        ? AppColors.happyGreen
                        : const Color(0xFF0284C7),
                    onRefresh: cargarInicio,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                      child: Column(
                        children: [
                          _header(),
                          const SizedBox(height: 20),
                          _botonCentroSolicitudes(),
                          const SizedBox(height: 20),
                          _meta(),
                          const SizedBox(height: 20),
                          _cards(),
                          const SizedBox(height: 20),
                          _resumen(),
                          const SizedBox(height: 20),
                          _ranking(),
                          const SizedBox(height: 20),
                          _rankingTiendas(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _header() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nombre = inicioData?.nombre ?? '';
    final fotoUrl = inicioData?.fotoUrl ?? '';
    final fotoCompleta = _fotoPerfilUrl(fotoUrl);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF0F2A44),
                  const Color(0xFF1677FF),
                ]
              : [
                  const Color(0xFFFFFFFF),
                  const Color(0xFFDCEEFF),
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.10)
              : Colors.black.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.20 : 0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor:
                isDark ? Colors.white.withOpacity(0.20) : Colors.white,
            backgroundImage: fotoCompleta.isNotEmpty
                ? NetworkImage(fotoCompleta)
                : null,
            child: fotoCompleta.isEmpty
                ? Text(
                    _iniciales(nombre),
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0284C7),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _capitalizarNombre(nombre),
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFBFCF03)
                        : const Color(0xFF0F3558),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFC2D100), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      inicioData?.cargo ?? "Vendedor",
                      style: const TextStyle(
                        color: Color(0xFFC2D100),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: _cerrarSesion,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.16)
                    : const Color(0xFF0284C7).withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.logout,
                color: isDark ? Colors.white : const Color(0xFF0284C7),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonCentroSolicitudes() {
  final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: _abrirCentroSolicitudes,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.happyGreen,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.happyBlue,
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.18 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment,
              color: AppColors.happyBlue,
              size: 22,
            ),
            SizedBox(width: 8),
            Text(
              "CENTRO DE SOLICITUDES",
              style: TextStyle(
                color: AppColors.happyBlue,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

    void _abrirCentroSolicitudes() {
  String tipoSolicitud = 'Permiso';
  String tipoPermiso = 'Estudios';
  bool confirmado = false;

  final nombreController = TextEditingController(
    text: inicioData?.nombre ?? '',
  );
  final cedulaController = TextEditingController(
    text: inicioData?.cedula ?? '',
  );
  final cargoController = TextEditingController(
    text: inicioData?.cargo ?? '',
  );
  final tiendaController = TextEditingController(
    text: inicioData?.tienda ?? '',
  );
  final jefeController = TextEditingController();
  final fechaSolicitudController = TextEditingController(
    text: DateTime.now().toString().substring(0, 10),
  );

  // Permiso
  final fechaPermisoController = TextEditingController();
  final horaInicioPermisoController = TextEditingController();
  final horaFinPermisoController = TextEditingController();

  // Vacación
  final fechaInicioVacacionController = TextEditingController();
  final fechaFinVacacionController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            insetPadding: const EdgeInsets.all(14),
            backgroundColor: isDark ? const Color(0xFF081B2E) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 650,
                maxHeight: 760,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _solicitudHeader(isDark),

                    const SizedBox(height: 10),

                    Text(
                      "Registre solicitudes de permisos o vacaciones.",
                      style: TextStyle(
                        color: isDark
                            ? Colors.white.withOpacity(0.70)
                            : const Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _solicitudSeccionTitulo(
                      "1. DATOS DEL COLABORADOR",
                      isDark,
                    ),

                    const SizedBox(height: 12),

                    _campoSolicitud(
                      "Nombre",
                      nombreController,
                      isDark,
                      readOnly: true,
                    ),
                    _campoSolicitud(
                      "Cédula",
                      cedulaController,
                      isDark,
                      readOnly: true,
                    ),
                    _campoSolicitud(
                      "Cargo",
                      cargoController,
                      isDark,
                      readOnly: true,
                    ),
                    _campoSolicitud(
                      "Tienda / Almacén actual",
                      tiendaController,
                      isDark,
                      readOnly: true,
                    ),
                    _campoSolicitud(
                      "Jefe inmediato",
                      jefeController,
                      isDark,
                    ),
                    _campoSolicitud(
                      "Fecha de solicitud",
                      fechaSolicitudController,
                      isDark,
                    ),

                    const SizedBox(height: 16),

                    _solicitudSeccionTitulo(
                      "2. TIPO DE SOLICITUD",
                      isDark,
                    ),

                    const SizedBox(height: 8),

                    _radioSolicitud(
                      value: 'Permiso',
                      groupValue: tipoSolicitud,
                      label: 'Permiso',
                      isDark: isDark,
                      onChanged: (value) {
                        setDialogState(() {
                          tipoSolicitud = value!;
                        });
                      },
                    ),

                    _radioSolicitud(
                      value: 'Vacación',
                      groupValue: tipoSolicitud,
                      label: 'Vacación',
                      isDark: isDark,
                      onChanged: (value) {
                        setDialogState(() {
                          tipoSolicitud = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    _solicitudSeccionTitulo(
                      "3. INFORMACIÓN DE LA SOLICITUD",
                      isDark,
                    ),

                    const SizedBox(height: 12),

                    if (tipoSolicitud == 'Permiso') ...[
                      _subtituloSolicitud(
                        "Información del Permiso",
                        isDark,
                      ),

                      _dropdownSolicitud(
                        label: "Tipo de permiso",
                        value: tipoPermiso,
                        items: const [
                          'Estudios',
                          'Enfermedad',
                        ],
                        isDark: isDark,
                        onChanged: (value) {
                          setDialogState(() {
                            tipoPermiso = value ?? 'Estudios';
                          });
                        },
                      ),

                      _campoSolicitud(
                        "Fecha",
                        fechaPermisoController,
                        isDark,
                      ),

                      _campoSolicitud(
                        "Hora de inicio",
                        horaInicioPermisoController,
                        isDark,
                      ),

                      _campoSolicitud(
                        "Hora de fin",
                        horaFinPermisoController,
                        isDark,
                      ),

                      _botonAdjuntoVisual(isDark),
                    ],

                    if (tipoSolicitud == 'Vacación') ...[
                      _subtituloSolicitud(
                        "Información de Vacación",
                        isDark,
                      ),

                      _campoSolicitud(
                        "Fecha de inicio",
                        fechaInicioVacacionController,
                        isDark,
                      ),

                      _campoSolicitud(
                        "Fecha de fin",
                        fechaFinVacacionController,
                        isDark,
                      ),
                    ],

                    const SizedBox(height: 16),

                    _solicitudSeccionTitulo(
                      "4. CONFIRMACIÓN",
                      isDark,
                    ),

                    const SizedBox(height: 8),

                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.happyGreen,
                      value: confirmado,
                      onChanged: (value) {
                        setDialogState(() {
                          confirmado = value ?? false;
                        });
                      },
                      title: Text(
                        "Confirmo que la información registrada es correcta.",
                        style: TextStyle(
                          color: isDark
                              ? Colors.white.withOpacity(0.80)
                              : const Color(0xFF334155),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.end,
                      children: [
                        _botonFormulario(
                          texto: "Guardar Solicitud",
                          icono: Icons.save,
                          color: AppColors.happyGreen,
                          textColor: AppColors.happyBlue,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  confirmado
                                      ? "Solicitud registrada visualmente. Falta conectar con backend."
                                      : "Debe confirmar que la información es correcta.",
                                ),
                              ),
                            );
                          },
                        ),

                        _botonFormulario(
                          texto: "Limpiar",
                          icono: Icons.cleaning_services,
                          color: Colors.orangeAccent,
                          textColor: Colors.white,
                          onTap: () {
                            setDialogState(() {
                              tipoSolicitud = 'Permiso';
                              tipoPermiso = 'Estudios';

                              jefeController.clear();

                              fechaPermisoController.clear();
                              horaInicioPermisoController.clear();
                              horaFinPermisoController.clear();

                              fechaInicioVacacionController.clear();
                              fechaFinVacacionController.clear();

                              confirmado = false;
                            });
                          },
                        ),

                        _botonFormulario(
                          texto: "Imprimir",
                          icono: Icons.print,
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Función de impresión pendiente.",
                                ),
                              ),
                            );
                          },
                        ),

                        _botonFormulario(
                          texto: "Cerrar",
                          icono: Icons.close,
                          color: Colors.redAccent,
                          textColor: Colors.white,
                          onTap: () {
                            Navigator.pop(dialogContext);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
  

  Widget _dropdownSolicitud({
  required String label,
  required String value,
  required List<String> items,
  required bool isDark,
  required ValueChanged<String?> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      dropdownColor: isDark ? const Color(0xFF0F2A44) : Colors.white,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF0F172A),
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark
              ? Colors.white.withOpacity(0.62)
              : const Color(0xFF64748B),
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0F2A44) : const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.06),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.06),
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


  Widget _solicitudHeader(bool isDark) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF0F2A44) : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06),
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            "HAPPY",
            style: TextStyle(
              color: AppColors.happyGreen,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "SOLICITUDES ADMINISTRATIVAS",
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.happyBlue,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 3),
            Text(
              "Permisos • Cambios • Gestión",
              style: TextStyle(
                color: isDark ? Colors.white.withOpacity(0.65) : const Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _solicitudSeccionTitulo(String titulo, bool isDark) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF0F2A44) : const Color(0xFFEFF6FF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      titulo,
      style: TextStyle(
        color: isDark ? AppColors.happyGreen : AppColors.happyBlue,
        fontSize: 13,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

Widget _subtituloSolicitud(String texto, bool isDark) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      texto,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF0F172A),
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _campoSolicitud(
  String label,
  TextEditingController controller,
  bool isDark, {
  bool readOnly = false,
  int maxLines = 1,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF0F172A),
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? Colors.white.withOpacity(0.62) : const Color(0xFF64748B),
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0F2A44) : const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06),
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

  Widget _radioSolicitud({
    required String value,
    required String groupValue,
    required String label,
    required bool isDark,
    required ValueChanged<String?> onChanged,
  }) {
    return RadioListTile<String>(
      contentPadding: EdgeInsets.zero,
      dense: true,
      activeColor: AppColors.happyGreen,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Text(
        label,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF0F172A),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _botonAdjuntoVisual(bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.attach_file,
            color: isDark ? AppColors.happyGreen : AppColors.happyBlue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Adjuntar respaldo",
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            "Pendiente",
            style: TextStyle(
              color: isDark ? Colors.white.withOpacity(0.50) : const Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonFormulario({
    required String texto,
    required IconData icono,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, color: textColor, size: 17),
            const SizedBox(width: 6),
            Text(
              texto,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }


// Resumen Section

    Widget _resumen() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final valueColor = isDark ? AppColors.happyGreen : const Color(0xFF19375F);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: Color(0xFFC2D100)),
              const SizedBox(width: 6),
              Text(
                "Mi resumen",
                style: TextStyle(
                  color: titleColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _miniCard(
                  "Ventas Hoy",
                  "${inicioData?.ventasHoy ?? 0}",
                  "ventas del día",
                  valueColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _miniCard(
                  "Ventas Mes",
                  "${inicioData?.ventasMesActual ?? 0}",
                  "mes actual",
                  valueColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _miniCard(
                  "Total Mes",
                  "\$${_formatearDecimal(inicioData?.totalDolaresMesActual ?? 0)}",
                  "vendido este mes",
                  valueColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _miniCard(
                  "Ticket Mes",
                  "\$${_formatearDecimal(inicioData?.ticketPromedio ?? 0)}",
                  "promedio por factura",
                  valueColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _miniCard(
                  "Productividad",
                  "${_formatearDecimal(inicioData?.productividad ?? 0)}/día",
                  "${inicioData?.diasTranscurridos ?? 0} días del mes",
                  valueColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _miniCard(
                  "Puntos Totales",
                  _formatearNumero(inicioData?.puntosTotales ?? 0),
                  "pts disponibles",
                  valueColor,
                ),
              ),
            ],
          ),
        ],
      );
    }

  Widget _miniCard(
  String title,
  String value,
  String subtitle,
  Color valueColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardTitleColor =
        isDark ? AppColors.happyGreen : AppColors.happyBlue;

    final cardValueColor =
        isDark ? Colors.white : AppColors.happyGreen;

    final cardSubtitleColor =
        isDark ? Colors.white.withOpacity(0.65) : AppColors.mutedLight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.14 : 0.06),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: cardTitleColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: cardValueColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: cardSubtitleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _meta() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final porcentajeReal = inicioData?.porcentajeCumplimiento ?? 0;
    final porcentajeBarra = porcentajeReal.clamp(0, 100);
    final progreso = porcentajeBarra / 100;

    final vendido = inicioData?.totalDolaresMeta ?? 0;
    final meta = inicioData?.metaDolares ?? 0;
    final falta = inicioData?.faltanteMeta ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F2A44) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.14 : 0.06),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.track_changes, color: Colors.redAccent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Meta de Ventas",
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _metaDato(
                  titulo: "Vendido",
                  valor: "\$${_formatearDecimal(vendido)}",
                  color: isDark ? AppColors.happyGreen : AppColors.happyGreen,
                ),
              ),
              Expanded(
                child: _metaDato(
                  titulo: "Meta",
                  valor: "\$${_formatearDecimal(meta)}",
                  color:isDark ? Colors.lightBlueAccent : Color(0xFF19375F),
                ),
              ),
              Expanded(
                child: _metaDato(
                  titulo: "Falta",
                  valor: "\$${_formatearDecimal(falta)}",
                  color: AppColors.happyGreen,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 8,
              backgroundColor: isDark
                  ? const Color.fromARGB(181, 37, 120, 210)
                  : const Color(0xFFE2E8F0),
              color: const Color(0xFFC2D102),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Text(
                  "${porcentajeReal.toStringAsFixed(2)}% de cumplimiento",
                  style: TextStyle(
                    color: isDark ? AppColors.happyGreen : const Color(0xFF059669),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "Falta ${_formatearDecimal(inicioData?.porcentajeFaltante ?? 0)}%",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.04),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "💡",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    inicioData?.comentarioMeta ?? '',
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.72)
                          : const Color(0xFF475569),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaDato({
    required String titulo,
    required String valor,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(
            color: isDark
                ? Colors.white.withOpacity(0.55)
                : const Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _cards() {
    return Row(
      children: [
        Expanded(
          child: _bigCard(
            "\$${_formatearDecimal(inicioData?.metaDolares ?? 0)}",
            "Meta",
            const LinearGradient(
              colors: [Color(0xFF063D77), Color(0xFF0A4E92)],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _bigCard(
            "${(inicioData?.porcentajeCumplimiento ?? 0).toStringAsFixed(2)}%",
            "Cumplimiento",
            const LinearGradient(
              colors: [Color(0xFF164C32), Color(0xFF224D36)],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _bigCard(
            "#${inicioData?.ranking ?? 0}",
            "Ranking",
            const LinearGradient(
              colors: [Color(0xFF5B4615), Color(0xFF65511B)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bigCard(String value, String title, Gradient gradient) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 12,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ranking() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final top = inicioData?.topVendedores ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber),
            const SizedBox(width: 6),
            Text(
              "Ranking de Vendedores",
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...top.map((item) => _rankingItem(item)).toList(),
      ],
    );
  }

  Widget _rankingTiendas() {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final topTiendas = inicioData?.topTiendas ?? [];
  final rankingTienda = inicioData?.rankingTienda ?? 0;
  final tiendaUsuario = inicioData?.tienda ?? '';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Icon(Icons.storefront, color: AppColors.happyGreen),
          const SizedBox(width: 6),
          Text(
            "Ranking de Tiendas",
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textLight,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),

      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : AppColors.borderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.13 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Text(
          "Competición por cumplimiento de meta en dólares. Tu equipo está en ${rankingTienda}ª posición nacional.",
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.mutedLight,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      const SizedBox(height: 12),

      ...topTiendas.map((tienda) {
        final esMiTienda = tienda.nombreTienda == tiendaUsuario;
        return _itemTienda(tienda, esMiTienda);
      }).toList(),
    ],
  );
}

  Widget _itemTienda(TopTiendaModel tienda, bool esMiTienda) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: esMiTienda
            ? AppColors.happyGreen
            : isDark
                ? Colors.white.withOpacity(0.06)
                : AppColors.borderLight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.13 : 0.06),
          blurRadius: 12,
          offset: const Offset(0, 7),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Text(
            "${tienda.posicion}°",
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tienda.nombreTienda,
                      style: const TextStyle(
                        color: AppColors.happyGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (esMiTienda)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.happyGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Tu Tienda",
                        style: TextStyle(
                          color: AppColors.happyBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "${tienda.porcentajeCumplimiento.toStringAsFixed(2)}% de cumplimiento",
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.happyBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _rankingItem(TopVendedorModel item) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final esUsuario = item.cedula == cedulaActual;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: esUsuario
            ? AppColors.happyGreen
            : isDark
                ? Colors.white.withOpacity(0.06)
                : AppColors.borderLight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.13 : 0.06),
          blurRadius: 12,
          offset: const Offset(0, 7),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Text(
            "${item.posicion}°",
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _capitalizarNombre(item.nombre),
                      style: TextStyle(
                        color: isDark ? AppColors.happyGreen :AppColors.happyGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (esUsuario)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.happyGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Tú",
                        style: TextStyle(
                          color: AppColors.happyBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "${item.totalVentas} ventas · Hoy ${item.ventasHoy} · ${item.porcentajeCumplimiento.toStringAsFixed(2)}%",
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.happyBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
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

  String _formatearNumero(int numero) {
    final texto = numero.toString();
    final buffer = StringBuffer();
    int count = 0;

    for (int i = texto.length - 1; i >= 0; i--) {
      buffer.write(texto[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write(',');
        count = 0;
      }
    }

    return buffer.toString().split('').reversed.join();
  }

  String _formatearDecimal(double numero) {
    return numero.toStringAsFixed(2);
  }
}