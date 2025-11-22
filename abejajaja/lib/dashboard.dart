import 'package:flutter/material.dart';
import 'package:abejajaja/colmenas.dart';
import 'dart:math' as math;

// ----------------------------------------------------------------------
// WIDGET AUXILIAR: HexagonPainter (para la gráfica de producción)
// ----------------------------------------------------------------------
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

    // Calcula los 6 puntos del hexágono
    final List<Offset> points = List.generate(6, (index) {
      final double angle = math.pi / 3 * index + math.pi / 6;
      return Offset(
        centerX + radius * math.cos(angle),
        centerY + radius * math.sin(angle),
      );
    });

    final Path path = Path()..addPolygon(points, true);

    // Dibuja las sombras primero
    for (final shadow in boxShadows) {
      canvas.drawShadow(path, shadow.color, shadow.blurRadius, false);
    }

    // Dibuja el relleno
    final Paint fillPaint = Paint()..color = color;
    canvas.drawPath(path, fillPaint);

    // Dibuja el borde
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

// ----------------------------------------------------------------------
// CLASE PRINCIPAL: DASHBOARDPAGE
// ----------------------------------------------------------------------
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
                // CAMBIO: Se ajusta esta tarjeta
                Expanded(child: _construirTarjetaDashboard(
                  icon: Icons.check_circle_outline,
                  title: "Colmenas Saludables",
                  value: "22 colmenas",
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

            // ------------------------------------------
            // ---- CALENDARIO / AGENDA VISUAL ----
            // ------------------------------------------
            const Text(
              "🗓️ Agenda y Próximas Tareas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _construirItemAgenda(
                      date: "Lun, 24 Jun",
                      task: "Revisión Sanitaria",
                      colmena: "#5, #7, #15",
                      color: Colors.blue,
                    ),
                    const Divider(height: 1, color: Colors.black12),
                    // Tarea de Tratamiento ELIMINADA
                    _construirItemAgenda(
                      date: "Jue, 27 Jun",
                      task: "Alimentación (Sirope)",
                      colmena: "Apiario Norte",
                      color: Colors.amber,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            // ------------------------------------------

            // ---- Alertas y Recordatorios URGENTES ----
            const Text(
              "⚠️ Alertas URGENTES",
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
              icon: Icons.restaurant_outlined,
              text: "Falta alimentación en **colmena #7**",
              time: "hace 3 días",
              color: Colors.blue[100],
              iconColor: Colors.blue[800],
            ),

            const SizedBox(height: 10),

            Center(
              child: Text(
                "Ver todos los eventos y alarmas",
                style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ---- Gráfica de Panal de Productos (Horizontal con Interlock) ----
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
                child: _construirGraficaPanalInterconectado(),
              ),
            ),

            const SizedBox(height: 30),

            // ---- Acciones Rápidas ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Ajuste para 2 botones
              children: [
                _construirBotonAccion(Icons.add, "Agregar\nColmena", () {}),
                _construirBotonAccion(Icons.checklist, "Registrar\nRevisión", () {}),
                // Botón de Tratamiento ELIMINADO
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

  // -------------------
  // Widgets reutilizables
  // -------------------

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

  // Widget para ítems de la Agenda / Calendario
  Widget _construirItemAgenda({
    required String date,
    required String task,
    required String colmena,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            alignment: Alignment.center,
            child: Text(
              date.split(',').first, // Día de la semana
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                Text(
                  "$colmena · ${date.split(',').last.trim()}", // Colmenas y fecha
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
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

  // FUNCIÓN DE GRÁFICA DE PANAL DE PRODUCTOS (Horizontal con Interlock)
  Widget _construirGraficaPanalInterconectado() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // MIEL (Posición normal)
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
        // POLEN (Desplazado hacia abajo para el efecto de interlock)
        Expanded(
          child: Transform.translate(
            offset: const Offset(0, 15),
            child: Center(
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
        // CERA (Posición normal)
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

  // Widget auxiliar para construir cada hexágono con su contenido (usa CustomPainter)
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