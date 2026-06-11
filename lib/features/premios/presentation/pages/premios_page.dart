import 'package:flutter/material.dart';
import '../../data/datasource/premios_remote_datasource.dart';
import '../../data/models/premio_model.dart';
import '../widgets/canje_comprobante_dialog.dart';

class PremiosPage extends StatefulWidget {
  final String cedula;

  const PremiosPage({
    super.key,
    required this.cedula,
  });

  @override
  State<PremiosPage> createState() => _PremiosPageState();
}

class _PremiosPageState extends State<PremiosPage> {
  final PremiosRemoteDataSource dataSource = PremiosRemoteDataSource();

  List<PremioModel> disponibles = [];
  List<PremioModel> proximos = [];
  List<HistorialPremioModel> historial = [];

  bool isLoading = true;
  String error = '';
  int tabIndex = 0;

  String get cedulaActual => widget.cedula;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _backgroundColor =>
      _isDark ? const Color(0xFF081B2E) : const Color.fromARGB(255, 220, 224, 228);

  Color get _cardColor =>
      _isDark ? const Color(0xFF0F2A44) : Colors.white;

  Color get _titleColor =>
      _isDark ? Colors.white : const Color(0xFF0F172A);

  Color get _subtitleColor =>
      _isDark ? Colors.white.withOpacity(0.68) : const Color(0xFF64748B);

  Color get _mutedColor =>
      _isDark ? Colors.white.withOpacity(0.45) : const Color(0xFF94A3B8);

  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.10) : Colors.black.withOpacity(0.06);

  Color get _primaryBlue =>
      _isDark ? Colors.lightBlueAccent : const Color(0xFF0284C7);

  Color get _successColor =>
      _isDark ? Colors.greenAccent : const Color(0xFF059669);

  @override
  void initState() {
    super.initState();
    cargarPremios();
  }

  Future<void> cargarPremios() async {
    try {
      final result = await dataSource.getPremios(cedulaActual);

      if (!mounted) return;

      setState(() {
        disponibles = result['disponibles'] ?? [];
        proximos = result['proximos'] ?? [];
        historial = result['historial'] ?? [];
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

  int get puntosDisponiblesHeader {
    if (disponibles.isNotEmpty) {
      return disponibles.first.puntosDisponibles;
    }
    if (proximos.isNotEmpty) {
      return proximos.first.puntosDisponibles;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: _successColor,
                ),
              )
            : error.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
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
                : RefreshIndicator(
                    color: _primaryBlue,
                    onRefresh: cargarPremios,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 115),
                      child: Column(
                        children: [
                          _header(),
                          const SizedBox(height: 20),
                          _tabs(),
                          const SizedBox(height: 20),
                          if (tabIndex == 0) ...[
                            _disponibles(),
                            const SizedBox(height: 20),
                            _proximos(),
                          ] else ...[
                            _historial(),
                          ],
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(radius: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recompensas",
            style: TextStyle(
              color: _titleColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Puntos Disponibles",
                style: TextStyle(
                  color: _subtitleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatearNumero(puntosDisponiblesHeader),
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _tabs() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: _cardDecoration(radius: 20),
      child: Row(
        children: [
          _tab("Catálogo", 0, Icons.card_giftcard_outlined),
          _tab("Historial", 1, Icons.history),
        ],
      ),
    );
  }

  Widget _tab(String text, int index, IconData icon) {
    final active = tabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            tabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? (_isDark ? Colors.lime : const Color(0xFFE0F2FE))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: active
                    ? (_isDark ? Colors.black : const Color(0xFF0284C7))
                    : _subtitleColor,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: active
                      ? (_isDark ? Colors.black : const Color(0xFF0284C7))
                      : _subtitleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _disponibles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          icon: Icons.check_circle,
          iconColor: _successColor,
          title: "Disponibles para Canjear",
        ),
        const SizedBox(height: 12),
        if (disponibles.isEmpty)
          _emptyCard("No hay premios disponibles por ahora.")
        else
          ...disponibles.map((premio) => _itemDisponible(premio)),
      ],
    );
  }

  Widget _itemDisponible(PremioModel premio) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isDark
              ? [
                  const Color(0xFF0C5C4E).withOpacity(0.55),
                  const Color(0xFF0A2437),
                ]
              : [
                  const Color(0xFFD1FAE5),
                  Colors.white,
                ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _isDark
              ? Colors.greenAccent.withOpacity(0.85)
              : const Color(0xFF10B981),
        ),
        boxShadow: _shadow(),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            child: Icon(
              _getPremioIcon(premio.descripcion),
              color: _isDark ? Colors.white70 : const Color(0xFF047857),
              size: 38,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  premio.descripcion,
                  style: TextStyle(
                    color: _titleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${_formatearNumero(premio.puntosRequeridos)} pts",
                  style: TextStyle(
                    color: _successColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Electrónica",
                  style: TextStyle(
                    color: _subtitleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF19C58E),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => _confirmarCanje(premio),
            child: const Text(
              "Canjear",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _proximos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          icon: Icons.lock_outline,
          iconColor: _mutedColor,
          title: "Próximas Recompensas",
        ),
        const SizedBox(height: 12),
        if (proximos.isEmpty)
          _emptyCard("No hay próximos premios.")
        else
          ...proximos.map((premio) => _itemBloqueado(premio)),
      ],
    );
  }

  Widget _itemBloqueado(PremioModel premio) {
    final int disponiblesActuales = premio.puntosDisponibles;
    final int requeridos = premio.puntosRequeridos;

    double progress = 0;
    if (requeridos > 0) {
      progress = disponiblesActuales / requeridos;
      if (progress > 1) progress = 1;
      if (progress < 0) progress = 0;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(radius: 18),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                child: Icon(
                  _getPremioIcon(premio.descripcion),
                  color: _mutedColor,
                  size: 38,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      premio.descripcion,
                      style: TextStyle(
                        color: _titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Electrónica",
                      style: TextStyle(
                        color: _subtitleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${_formatearNumero(premio.puntosRequeridos)} pts",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.lock_outline, size: 14, color: _mutedColor),
                      const SizedBox(width: 4),
                      Text(
                        "Bloqueado",
                        style: TextStyle(
                          color: _mutedColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor:
                  _isDark ? Colors.white12 : const Color(0xFFE2E8F0),
              color: Colors.lime,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Te faltan ",
                    style: TextStyle(
                      color: _subtitleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: "${premio.puntosFaltantes ?? 0}",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " pts",
                    style: TextStyle(
                      color: _subtitleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historial() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          icon: Icons.history,
          iconColor: _primaryBlue,
          title: "Historial de Canjes",
        ),
        const SizedBox(height: 12),
        if (historial.isEmpty)
          _emptyCard("Todavía no tienes canjes registrados.")
        else
          ...historial.map((item) => _itemHistorial(item)),
      ],
    );
  }

  Widget _itemHistorial(HistorialPremioModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(radius: 18),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            child: Icon(
              _getPremioIcon(item.descripcion),
              color: _primaryBlue,
              size: 36,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.descripcion,
                  style: TextStyle(
                    color: _titleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatearFecha(item.fechaCanjeo),
                  style: TextStyle(
                    color: _subtitleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${_formatearNumero(item.puntosUsados)} pts usados",
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.codigoCanje,
                  style: TextStyle(
                    color: _primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle({
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            color: _titleColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _emptyCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(radius: 16),
      child: Text(
        text,
        style: TextStyle(
          color: _subtitleColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _confirmarCanje(PremioModel premio) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        return AlertDialog(
          backgroundColor:
              isDark ? const Color(0xFF0F2A44) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            'Confirmar canje',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Deseas canjear ${premio.descripcion} por ${premio.puntosRequeridos} pts?',
            style: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.70)
                  : const Color(0xFF475569),
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: isDark
                      ? Colors.lightBlueAccent
                      : const Color(0xFF0284C7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF19C58E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Canjear'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    try {
      final comprobante = await dataSource.canjearPremio(
        cedula: cedulaActual,
        codigoBarras: premio.codigoBarras,
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CanjeComprobanteDialog(
          comprobante: comprobante,
        ),
      );

      if (!mounted) return;

      setState(() {
        isLoading = true;
      });

      await cargarPremios();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al canjear: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  BoxDecoration _cardDecoration({required double radius}) {
    return BoxDecoration(
      color: _cardColor,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: _borderColor),
      boxShadow: _shadow(),
    );
  }

  List<BoxShadow> _shadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(_isDark ? 0.14 : 0.06),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ];
  }

  IconData _getPremioIcon(String descripcion) {
    final desc = descripcion.toLowerCase();

    if (desc.contains('aud') || desc.contains('audí')) {
      return Icons.headphones;
    }
    if (desc.contains('parlante') || desc.contains('boom')) {
      return Icons.volume_up;
    }
    if (desc.contains('watch') || desc.contains('smartwatch')) {
      return Icons.watch;
    }
    if (desc.contains('gafas')) {
      return Icons.visibility_outlined;
    }
    if (desc.contains('telefono') || desc.contains('teléfono')) {
      return Icons.smartphone;
    }
    return Icons.card_giftcard;
  }

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return 'Sin fecha';

    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year} '
        '${fecha.hour.toString().padLeft(2, '0')}:'
        '${fecha.minute.toString().padLeft(2, '0')}';
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
}