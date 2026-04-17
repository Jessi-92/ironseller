import 'package:flutter/material.dart';

class RendimientoPage extends StatefulWidget {
  const RendimientoPage({super.key});

  @override
  State<RendimientoPage> createState() => _RendimientoPageState();
}

class _RendimientoPageState extends State<RendimientoPage> {
  int selectedDayIndex = 0;

  final List<String> dias = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
  ];

  final List<double> ventasSemanales = [14, 18, 12, 16, 20, 15, 0];
  final List<String> diasSemana = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

  final List<double> comisionesMes = [2100, 2350, 2200, 2845];
  final List<String> meses = ['Ene', 'Feb', 'Mar', 'Abr'];

  final Map<int, List<double>> ventasPorHora = {
    0: [25, 45, 60, 118, 92, 70, 55, 75, 108, 128, 112, 80],
    1: [20, 40, 55, 100, 84, 65, 52, 68, 99, 120, 105, 76],
    2: [18, 35, 50, 95, 77, 60, 49, 70, 102, 118, 100, 72],
    3: [22, 44, 58, 110, 88, 68, 53, 72, 107, 125, 110, 78],
    4: [28, 48, 62, 120, 96, 72, 58, 78, 112, 132, 116, 84],
    5: [16, 30, 42, 82, 65, 48, 39, 55, 85, 95, 88, 60],
  };

  final List<String> horas = [
    '9am',
    '10am',
    '11am',
    '12pm',
    '1pm',
    '2pm',
    '3pm',
    '4pm',
    '5pm',
    '6pm',
    '7pm',
    '8pm',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081B2E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mi Rendimiento',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _topCards(),
              const SizedBox(height: 20),
              _ventasVsMeta(),
              const SizedBox(height: 20),
              _evolucionComisiones(),
              const SizedBox(height: 20),
              _planVenta(),
              const SizedBox(height: 20),
              _misionesInteligentes(),
              const SizedBox(height: 20),
              _beneficiosVendidos(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 0.92,
      children: [
        _metricCard(
          icon: Icons.attach_money,
          value: '\$2,845',
          title: 'Comisiones del Mes',
          subtitle: '+15% vs mes anterior',
          gradient: const LinearGradient(
            colors: [Color(0xFF063D77), Color(0xFF0A4E92)],
          ),
          iconColor: Colors.lightBlueAccent,
        ),
        _metricCard(
          icon: Icons.gps_fixed,
          value: '87%',
          title: 'Tasa de Conversión',
          subtitle: '+5% vs promedio',
          gradient: const LinearGradient(
            colors: [Color(0xFF0C534B), Color(0xFF0A3A39)],
          ),
          iconColor: Colors.greenAccent,
        ),
        _metricCard(
          icon: Icons.insert_chart_outlined,
          value: '95',
          title: 'Ventas del Mes',
          subtitle: '+12 vs meta',
          gradient: const LinearGradient(
            colors: [Color(0xFF4C4518), Color(0xFF2C3324)],
          ),
          iconColor: Colors.amber,
        ),
        _metricCard(
          icon: Icons.trending_up,
          value: '\$385',
          title: 'Ticket Promedio',
          subtitle: '+\$42 vs anterior',
          gradient: const LinearGradient(
            colors: [Color(0xFF252A71), Color(0xFF1B215C)],
          ),
          iconColor: Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String value,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ventasVsMeta() {
    return _sectionCard(
      title: 'Ventas Semanales vs Meta',
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(diasSemana.length, (index) {
                final value = ventasSemanales[index];
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 18,
                            height: value * 8,
                            decoration: BoxDecoration(
                              color: index == 6
                                  ? Colors.white10
                                  : const Color(0xFF4D688B),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        diasSemana[index],
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: Color(0xFF1DA1F2), text: 'Ventas Reales'),
              SizedBox(width: 20),
              _LegendDot(color: Color(0xFF4D688B), text: 'Meta Diaria'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _evolucionComisiones() {
    return _sectionCard(
      title: 'Evolución de Comisiones',
      child: SizedBox(
        height: 220,
        child: CustomPaint(
          painter: LineChartPainter(
            values: comisionesMes,
            maxValue: 3000,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36, 16, 20, 28),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: meses
                  .map(
                    (mes) => Text(
                      mes,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _planVenta() {
    final data = ventasPorHora[selectedDayIndex] ?? [];

    return _sectionCard(
      title: 'Plan de Venta',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: dias.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final selected = selectedDayIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDayIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF1DA1F2)
                          : const Color(0xFF22374D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      dias[index],
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tráfico Peatonal vs Conversión',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 230,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(data.length, (index) {
                final value = data[index];
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 10,
                            height: value * 1.3,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1DA1F2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        horas[index],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: Colors.amber, text: 'Personas Pasando'),
              SizedBox(width: 20),
              _LegendDot(color: Color(0xFF1DA1F2), text: 'Ventas Realizadas'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _misionesInteligentes() {
    return _sectionCard(
      title: 'Misiones Inteligentes',
      icon: Icons.bolt,
      iconColor: Colors.amber,
      child: Column(
        children: [
          _misionCard(
            icon: '🎯',
            hora: '6pm',
            badge: 'Oportunidad',
            badgeColor: const Color(0xFFC28B00),
            text:
                '130 personas pasan, pero conversión 7%. ¡Sal a captar clientes y duplica tu conversión!',
            borderColor: Colors.amber.withOpacity(0.35),
            background: const LinearGradient(
              colors: [Color(0xFF3D3A24), Color(0xFF232B2E)],
            ),
          ),
          const SizedBox(height: 14),
          _misionCard(
            icon: '🔥',
            hora: '6pm',
            badge: 'Pico',
            badgeColor: const Color(0xFF008C74),
            text:
                'Hora pico: 130 personas pasan. Convierte 8 clientes y gana puntos bonus x2',
            borderColor: Colors.greenAccent.withOpacity(0.30),
            background: const LinearGradient(
              colors: [Color(0xFF0B4E4C), Color(0xFF0A2C35)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _misionCard({
    required String icon,
    required String hora,
    required String badge,
    required Color badgeColor,
    required String text,
    required Color borderColor,
    required Gradient background,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: Colors.white54, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      hora,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1.5,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _beneficiosVendidos() {
    return _sectionCard(
      title: 'Beneficios Vendidos',
      child: Column(
        children: const [
          _BenefitBar(
            title: 'Asistencia de Pantalla',
            value: '45 ventas (52%)',
            progress: 0.52,
            color: Color(0xFF1DA1F2),
          ),
          SizedBox(height: 16),
          _BenefitBar(
            title: 'Happy Connect',
            value: '28 ventas (32%)',
            progress: 0.32,
            color: Color(0xFF19C58E),
          ),
          SizedBox(height: 16),
          _BenefitBar(
            title: 'Atención Telemedicina',
            value: '14 ventas (16%)',
            progress: 0.16,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    Widget? child,
    IconData? icon,
    Color? iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? Colors.white, size: 22),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (child != null) ...[
            const SizedBox(height: 18),
            child,
          ]
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendDot({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}

class _BenefitBar extends StatelessWidget {
  final String title;
  final String value;
  final double progress;
  final Color color;

  const _BenefitBar({
    required this.title,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.white12,
            color: color,
          ),
        ),
      ],
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> values;
  final double maxValue;

  LineChartPainter({
    required this.values,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1;

    final axisPaint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 1.2;

    final linePaint = Paint()
      ..color = const Color(0xFF19C58E)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = const Color(0xFF19C58E)
      ..style = PaintingStyle.fill;

    const leftPadding = 36.0;
    const rightPadding = 10.0;
    const topPadding = 16.0;
    const bottomPadding = 32.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    for (int i = 0; i <= 4; i++) {
      final y = topPadding + (chartHeight / 4) * i;
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );
    }

    for (int i = 0; i < values.length; i++) {
      final x = leftPadding + (chartWidth / (values.length - 1)) * i;
      canvas.drawLine(
        Offset(x, topPadding),
        Offset(x, topPadding + chartHeight),
        gridPaint,
      );
    }

    canvas.drawLine(
      Offset(leftPadding, topPadding + chartHeight),
      Offset(size.width - rightPadding, topPadding + chartHeight),
      axisPaint,
    );

    canvas.drawLine(
      Offset(leftPadding, topPadding),
      Offset(leftPadding, topPadding + chartHeight),
      axisPaint,
    );

    final path = Path();

    for (int i = 0; i < values.length; i++) {
      final x = leftPadding + (chartWidth / (values.length - 1)) * i;
      final y = topPadding + chartHeight - ((values[i] / maxValue) * chartHeight);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.quadraticBezierTo(x, y, x, y);
      }

      canvas.drawCircle(Offset(x, y), 6, dotPaint);
    }

    canvas.drawPath(path, linePaint);

    final textStyle = const TextStyle(
      color: Colors.white60,
      fontSize: 11,
    );

    final labels = ['0', '700', '1400', '2100', '2800'];

    for (int i = 0; i < labels.length; i++) {
      final y = topPadding + chartHeight - (chartHeight / 4) * i;
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(2, y - 8));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}