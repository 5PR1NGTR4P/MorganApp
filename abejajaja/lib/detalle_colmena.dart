import 'package:flutter/material.dart';
import 'package:abejajaja/registro_actividad.dart';

class DetalleColmenaPage extends StatelessWidget {
  final String colmenaId;
  final String status;
  final Color statusColor;

  const DetalleColmenaPage({
    super.key,
    required this.colmenaId,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo según la colmena
    final datosColmena = _getDatosColmena(colmenaId);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          colmenaId,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Tarjeta de Estado Principal ----
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: statusColor.withOpacity(0.2),
                      child: Icon(
                        Icons.hive,
                        color: statusColor,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            datosColmena['estadoSanitario']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ---- Información Básica ----
            const Text(
              "Información General",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            _buildInfoCard(
              icon: Icons.calendar_today,
              title: "Fecha de Instalación",
              value: datosColmena['fechaInstalacion']!,
            ),
            _buildInfoCard(
              icon: Icons.leaderboard,
              title: "Tipo de Reina",
              value: datosColmena['tipoReina']!,
            ),
            _buildInfoCard(
              icon: Icons.account_tree,
              title: "Linaje",
              value: datosColmena['linaje']!,
            ),

            const SizedBox(height: 24),

            // ---- Producción y Estado Sanitario ----
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.money_outlined,
                            color: Colors.amber[700],
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Producción",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            datosColmena['produccion']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.health_and_safety,
                            color: statusColor,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Estado Sanitario",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            datosColmena['estadoSanitario']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ---- Historial ----
            const Text(
              "Historial de Actividades",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            _buildHistorialSection(
              "Inspecciones",
              Icons.checklist,
              datosColmena['inspecciones'] as List<String>,
            ),
            const SizedBox(height: 12),
            _buildHistorialSection(
              "Tratamientos",
              Icons.vaccines,
              datosColmena['tratamientos'] as List<String>,
            ),
            const SizedBox(height: 12),
            _buildHistorialSection(
              "Alimentaciones",
              Icons.restaurant,
              datosColmena['alimentaciones'] as List<String>,
            ),

            const SizedBox(height: 24),

            // ---- Botones de Acción ----
            const Text(
              "Registrar Actividad",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.checklist,
                    label: "Revisión",
                    color: Colors.blue[700]!,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.vaccines,
                    label: "Tratamiento",
                    color: Colors.orange[700]!,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.restaurant,
                    label: "Alimentación",
                    color: Colors.green[700]!,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getDatosColmena(String id) {
    // Datos de ejemplo según la colmena
    switch (id) {
      case "Colmena #1":
        return {
          'fechaInstalacion': '15 de marzo de 2023',
          'tipoReina': 'Italiana',
          'linaje': 'Carniola',
          'produccion': '22 kg',
          'estadoSanitario': 'Saludable',
          'inspecciones': [
            'Revisión completa - Hace 5 días\nEstado: Normal',
            'Revisión rutinaria - Hace 12 días\nEstado: Normal',
            'Revisión de producción - Hace 20 días\nEstado: Normal',
          ],
          'tratamientos': [
            'Tratamiento preventivo varroa - Hace 2 meses\nProducto: Apivar',
            'Tratamiento estacional - Hace 5 meses\nProducto: Ácido fórmico',
          ],
          'alimentaciones': [
            'Alimentación complementaria - Hace 3 semanas\nTipo: Jarabe de azúcar',
            'Alimentación estacional - Hace 2 meses\nTipo: Candy board',
          ],
        };
      case "Colmena #2":
        return {
          'fechaInstalacion': '20 de abril de 2023',
          'tipoReina': 'Carniola',
          'linaje': 'Buckfast',
          'produccion': '18 kg',
          'estadoSanitario': 'En revisión',
          'inspecciones': [
            'Revisión de emergencia - Ayer\nEstado: Revisión necesaria',
            'Revisión rutinaria - Hace 8 días\nEstado: Algunas anomalías',
          ],
          'tratamientos': [
            'Tratamiento preventivo - Hace 1 mes\nProducto: Apivar',
          ],
          'alimentaciones': [
            'Alimentación de apoyo - Hace 2 semanas\nTipo: Jarabe nutritivo',
          ],
        };
      case "Colmena #3":
        return {
          'fechaInstalacion': '10 de febrero de 2023',
          'tipoReina': 'Africana',
          'linaje': 'Híbrida',
          'produccion': '15 kg',
          'estadoSanitario': 'Problema detectado',
          'inspecciones': [
            'Revisión de emergencia - Hace 10 días\nEstado: Problema detectado - Varroa',
            'Revisión rutinaria - Hace 25 días\nEstado: Primeros signos de alerta',
          ],
          'tratamientos': [
            'Tratamiento de emergencia - Hace 8 días\nProducto: Apistan',
            'Tratamiento preventivo - Hace 3 meses\nProducto: Ácido oxálico',
          ],
          'alimentaciones': [
            'Alimentación terapéutica - Hace 1 semana\nTipo: Jarabe con medicamento',
            'Alimentación complementaria - Hace 1 mes\nTipo: Jarabe de azúcar',
          ],
        };
      case "Colmena #4":
        return {
          'fechaInstalacion': '5 de mayo de 2023',
          'tipoReina': 'Carniola',
          'linaje': 'Italiana',
          'produccion': '25 kg',
          'estadoSanitario': 'En tratamiento',
          'inspecciones': [
            'Revisión post-tratamiento - Hoy\nEstado: En seguimiento',
            'Revisión rutinaria - Hace 7 días\nEstado: Inicio de tratamiento',
          ],
          'tratamientos': [
            'Tratamiento activo - En curso\nProducto: Apivar (día 5 de 21)',
            'Tratamiento preventivo - Hace 2 meses\nProducto: Ácido fórmico',
          ],
          'alimentaciones': [
            'Alimentación durante tratamiento - Hace 2 días\nTipo: Jarabe nutritivo',
            'Alimentación complementaria - Hace 3 semanas\nTipo: Candy board',
          ],
        };
      default:
        return {
          'fechaInstalacion': 'Fecha no disponible',
          'tipoReina': 'No especificado',
          'linaje': 'No especificado',
          'produccion': '0 kg',
          'estadoSanitario': 'Desconocido',
          'inspecciones': <String>[],
          'tratamientos': <String>[],
          'alimentaciones': <String>[],
        };
    }
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.amber[700]),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildHistorialSection(String title, IconData icon, List<String> items) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.amber[700]),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "${items.length} registros",
          style: const TextStyle(fontSize: 12),
        ),
        children: items.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "No hay registros",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ]
            : items.map((item) {
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.circle, size: 8),
                  title: Text(
                    item,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: () {
        String tipoActividad = label.toLowerCase();
        if (tipoActividad == "revisión") {
          tipoActividad = "revision";
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistroActividadPage(
              colmenaId: colmenaId,
              tipoActividad: tipoActividad,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
