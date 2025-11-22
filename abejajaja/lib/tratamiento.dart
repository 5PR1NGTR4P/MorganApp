import 'package:flutter/material.dart';

class tratamiento extends StatelessWidget {
  final String numeroColmena;
  const tratamiento({super.key, required this.numeroColmena});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro en $numeroColmena", style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Registrar Tratamiento/Alimentación",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
            ),
            const SizedBox(height: 20),

            // --- Historial Reciente ---
            _construirTituloSeccion("Historial Reciente"),
            _construirItemHistorial("Tratamiento Varroa (Ácido)", "2025-10-15", "Dosis completa, efectivo.", Colors.blue[100]),
            _construirItemHistorial("Alimentación", "2025-11-01", "2L jarabe de azúcar. Aceptación alta.", Colors.green[100]),
            const SizedBox(height: 25),

            // --- Formulario de Registro ---
            _construirTituloSeccion("Nuevo Registro"),
            const TextField(decoration: InputDecoration(labelText: "Fecha")),
            const TextField(decoration: InputDecoration(labelText: "Tipo (Tratamiento/Alimentación)")),

            _construirTituloSeccion("Tratamiento Aplicado"),
            const TextField(decoration: InputDecoration(labelText: "Nombre del Tratamiento (Ej. Ácido Oxálico)")),
            const TextField(decoration: InputDecoration(labelText: "Dosis Aplicada")),
            const SizedBox(height: 20),

            _construirTituloSeccion("Alimentación (si aplica)"),
            const TextField(decoration: InputDecoration(labelText: "Tipo de Alimento (Ej. Jarabe de azúcar)")),
            const TextField(decoration: InputDecoration(labelText: "Cantidad (Ej. 1.5 Litros)")),
            const SizedBox(height: 20),

            _construirTituloSeccion("Notas y Adjuntos"),
            const TextField(
              decoration: InputDecoration(labelText: "Observaciones"),
              maxLines: 3,
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt),
              label: const Text("Adjuntar Foto"),
            ),

            _construirTituloSeccion("Alertas"),
            Row(
              children: [
                const Expanded(child: Text("Programar alerta para próximo tratamiento")),
                Switch(value: true, onChanged: (val) {}),
              ],
            ),

            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.green[600],
                ),
                child: const Text("Guardar Registro", style: TextStyle(fontSize: 18, color: Colors.white)),
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

  Widget _construirItemHistorial(String titulo, String fecha, String detalle, Color? color) {
    return Card(
      elevation: 0,
      color: color,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        leading: Icon(titulo.contains("Tratamiento") ? Icons.vaccines : Icons.restaurant, color: Colors.black87),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text("Fecha: $fecha. $detalle"),
      ),
    );
  }
}