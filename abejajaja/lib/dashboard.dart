import 'package:flutter/material.dart';
import 'package:abejajaja/colmenas.dart';
import 'package:abejajaja/tratamiento.dart';
import 'dart:math' as math;


class HexagonPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow> boxShadows;

  HexagonPainter({
    required this.color,
    this.borderColor = Colors.black12,
    this.borderWidth = 1.0,
    this.boxShadows = const [],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;


    final List<Offset> points = List.generate(6, (index) {
      final double angle = math.pi / 3 * index + math.pi / 6; // +pi/6 para que una cara sea horizontal
      return Offset(
        centerX + radius * math.cos(angle),
        centerY + radius * math.sin(angle),
      );
    });

    final Path path = Path()..addPolygon(points, true);


    for (final shadow in boxShadows) {
      canvas.drawShadow(path, shadow.color, shadow.blurRadius, false);
    }


    final Paint fillPaint = Paint()..color = color;
    canvas.drawPath(path, fillPaint);


    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Icon(Icons.notifications_none, color: Colors.black87),
          SizedBox(width: 16),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Tarjetas de Métricas ----
            Row(
              children: [
                Expanded(child: _construirTarjetaDashboard(
                  icon: Icons.hive_outlined,
                  title: "Total Colmenas",
                  value: "25",
                )),
                const SizedBox(width: 12),
                Expanded(child: _construirTarjetaDashboard(
                  icon: Icons.warning_amber_rounded,
                  title: "Por Revisar",
                  value: "3 colmenas",
                )),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: _construirTarjetaDashboard(
                  icon: Icons.medical_services_outlined,
                  title: "Tratamientos",
                  value: "2 urgentes",
                )),
                const SizedBox(width: 12),
                Expanded(child: _construirTarjetaDashboard(
                  icon: Icons.inventory_2_outlined,
                  title: "Producción '25",
                  value: "292 kg",
                )),
              ],
            ),

            const SizedBox(height: 24),

            // ---- Alertas y Recordatorios ----
            const Text(
              "Alertas y Recordatorios",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            _construirItemAlerta(
              icon: Icons.error_outline,
              text: "**Colmena #12** requiere revisión (posible varroa)",
              time: "hace 3 días",
              color: Colors.red[100],
              iconColor: Colors.red,
            ),
            _construirItemAlerta(
              icon: Icons.calendar_month_outlined,
              text: "**Colmena #5** tratamiento [Ácido fórmico] mañana",
              time: "Programado",
              color: Colors.amber[100],
              iconColor: Colors.amber[800],
            ),
            _construirItemAlerta(
              icon: Icons.restaurant_outlined,
              text: "Falta alimentación en **colmena #7**",
              time: "hace 3 días",
              color: Colors.blue[100],
              iconColor: Colors.blue[800],
            ),

            const SizedBox(height: 10),

            Center(
              child: Text(
                "Ver todas las alertas",
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ---- Gráfica de Panal de Productos  ----
            const Text(
              "Métricas Clave de Producción (Última Cosecha)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                height: 180,
                alignment: Alignment.center,
                child: _construirGraficaPanalInterconectado(), // <-- GRÁFICA CON HEXÁGONOS
              ),
            ),

            const SizedBox(height: 30),

            // ---- Acciones Rápidas ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _construirBotonAccion(Icons.add, "Agregar\nColmena", () {}),
                _construirBotonAccion(Icons.checklist, "Registrar\nRevisión", () {}),
                _construirBotonAccion(Icons.vaccines, "Registrar\nTratamiento", () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const tratamiento(numeroColmena: "Seleccionar Colmena"),
                  ));
                }),
              ],
            ),
            const SizedBox(height: 30),

          ],
        ),
      ),

      // ---- Navegación Inferior ----
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ColmenasPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hive),
            label: "Colmenas",
          ),
        ],
      ),
    );
  }



  Widget _construirTarjetaDashboard({required IconData icon, required String title, required String value}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Colors.orange[700]),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _construirItemAlerta({required IconData icon, required String text, required String time, Color? color, Color? iconColor}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(text, style: const TextStyle(fontSize: 15)),
        trailing: Text(time, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ),
    );
  }

  Widget _construirBotonAccion(IconData icono, String texto, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue[600],
            child: Icon(icono, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 6),
          Text(texto, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // FUNCIÓN DE GRÁFICA DE PANAL DE PRODUCTOS
  Widget _construirGraficaPanalInterconectado() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // MIEL
        Expanded(
          child: Center(
            child: _construirHexagonoConContenido(
              color: Colors.amber.shade700,
              icon: Icons.hive_outlined,
              valueText: "245 kg",
              labelText: "MIEL",
              size: 90,
            ),
          ),
        ),
        // POLEN
        Expanded(
          child: Center(
            child: Transform.translate(
              offset: const Offset(0, 15),
              child: _construirHexagonoConContenido(
                color: Colors.lightGreen.shade600,
                icon: Icons.spa_outlined,
                valueText: "35 kg",
                labelText: "POLEN",
                size: 90,
              ),
            ),
          ),
        ),
        // CERA
        Expanded(
          child: Center(
            child: _construirHexagonoConContenido(
              color: Colors.brown.shade400,
              icon: Icons.square_foot_outlined,
              valueText: "12 kg",
              labelText: "CERA",
              size: 90,
            ),
          ),
        ),
      ],
    );
  }

  // Widget auxiliar para construir cada hexágono
  Widget _construirHexagonoConContenido({
    required Color color,
    required IconData icon,
    required String valueText,
    required String labelText,
    required double size,
  }) {

    final List<BoxShadow> shadows = [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        spreadRadius: 1,
        blurRadius: 4,
        offset: const Offset(2, 2),
      ),
    ];

    return SizedBox(
      width: size,
      height: size * 1.15,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // CustomPainter para el hexágono
          CustomPaint(
            painter: HexagonPainter(color: color, boxShadows: shadows),
            size: Size(size, size * 1.15),
          ),
          // Contenido dentro del hexágono
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: size * 0.25),
              const SizedBox(height: 5),
              Text(
                valueText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                labelText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: size * 0.1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
