import 'package:flutter/material.dart';

class cosecha extends StatelessWidget {
  final String numeroColmena;
  const cosecha({super.key, required this.numeroColmena});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cosecha en $numeroColmena", style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Registro de Cosecha / Producción",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber[800]),
            ),
            const SizedBox(height: 20),

            // --- Gráfica de Historial de Colmena  ---
            _construirTituloSeccion("Rendimiento Histórico de esta Colmena"),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 180, // Aumentamos la altura para la gráfica 3D
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text("Producción de miel (kg) $numeroColmena", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Center(
                        child: _construirGraficaPanal3DSimulada(), // Grafica
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- Historial de Cosechas  ---
            _construirTituloSeccion("Cosechas Anteriores"),
            _construirItemCosecha("2025-07-20", "25.5 kg Miel", "Alta Calidad"),
            _construirItemCosecha("2024-07-15", "18.0 kg Miel", "Normal"),
            const SizedBox(height: 25),


            // --- Formulario de Registro ---
            _construirTituloSeccion("Nuevo Registro de Cosecha"),
            const TextField(decoration: InputDecoration(labelText: "Fecha de la Cosecha")),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Cantidad de Miel (kg)"),
            ),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Cantidad de Cera (kg)"),
            ),
            const SizedBox(height: 20),

            _construirTituloSeccion("Observaciones"),
            const TextField(
              decoration: InputDecoration(labelText: "Notas sobre la calidad o proceso"),
              maxLines: 3,
            ),

            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.amber[600],
                ),
                child: const Text("Guardar Cosecha", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _construirTituloSeccion(String titulo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        titulo,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _construirItemCosecha(String fecha, String cantidad, String calidad) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.star, color: Colors.amber),
        title: Text(cantidad, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text("Fecha: $fecha | Calidad: $calidad"),
      ),
    );
  }

  // GRÁFICA P
  Widget _construirGraficaPanal3DSimulada() {
    // Datos: (Producción simulada en kg)
    final List<Map<String, dynamic>> datos = [
      {'year': '2023', 'kg': 30.0, 'color': Colors.red.shade400, 'label': '30 kg'},
      {'year': '2024', 'kg': 38.0, 'color': Colors.amber.shade600, 'label': '38 kg'},
      {'year': '2025', 'kg': 45.0, 'color': Colors.blue.shade400, 'label': '45 kg'},
      {'year': 'Estimado.', 'kg': 50.0, 'color': Colors.grey.shade400, 'label': '50 kg'},
    ];

    // altura de los panales
    final double maxKg = datos.map((d) => d['kg'] as double).reduce((a, b) => a > b ? a : b);
    final double alturaBase = 120.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: datos.map((data) {
        double alturaRelativa = (data['kg'] / maxKg) * alturaBase;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Valor sobre el panal
            Text(data['label'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: data['color'])),
            const SizedBox(height: 5),


            Stack(
              alignment: Alignment.center,
              children: [
                // Fondo: Hexágono
                _construirPanal(25.0, data['color'].withOpacity(0.5), 0.523599),

                // Frente: Hexágono principal
                Transform.translate(
                  offset: const Offset(0, -2),
                  child: _construirPanal(
                    25.0,
                    data['color'],
                    0.523599,
                    altura: alturaRelativa.clamp(10.0, alturaBase), // Altura mínima y máxima
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(data['year'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        );
      }).toList(),
    );
  }

  // Widget auxiliar para construir un panal
  Widget _construirPanal(double size, Color color, double angle, {double altura = 0}) {
    Color colorFondo = (altura > 0) ? color : Colors.transparent;

    return Container(
      width: size,
      height: size,
      transform: Matrix4.rotationZ(angle),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black12, width: 1),
      ),
    );
  }
}