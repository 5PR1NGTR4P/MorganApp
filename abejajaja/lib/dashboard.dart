import 'package:flutter/material.dart';
import 'colmenas.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Mi Apiario",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
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
            
            // ---- Tarjetas del Dashboard ----
            Row(
              children: [
                Expanded(child: _buildDashboardCard(
                  icon: Icons.hive_outlined,
                  title: "Colmenas Totales",
                  value: "32",
                )),
                const SizedBox(width: 12),
                Expanded(child: _buildDashboardCard(
                  icon: Icons.warning_amber_rounded,
                  title: "Por Revisar",
                  value: "3 colmenas",
                )),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: _buildDashboardCard(
                  icon: Icons.medical_services_outlined,
                  title: "Tratamientos",
                  value: "2 esta semana",
                )),
                const SizedBox(width: 12),
                Expanded(child: _buildDashboardCard(
                  icon: Icons.inventory_2_outlined,
                  title: "Producción",
                  value: "18 kg",
                )),
              ],
            ),

            const SizedBox(height: 24),

            // ---- Alertas ----
            const Text(
              "Alertas y Recordatorios",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            _buildAlertItem(
              icon: Icons.error_outline,
              text: "Colmena #12 requiere revisión",
              time: "hace 3 días",
            ),
            _buildAlertItem(
              icon: Icons.calendar_month_outlined,
              text: "Colmena #5 tiene tratamiento mañana",
              time: "hace 3 días",
            ),
            _buildAlertItem(
              icon: Icons.restaurant_outlined,
              text: "Falta alimentación en colmena #7",
              time: "hace 3 días",
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

            // ---- Acciones Rápidas ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(Icons.add, "Agregar\nColmena"),
                _buildActionButton(Icons.checklist, "Registrar\nRevisión"),
                _buildActionButton(Icons.vaccines, "Registrar\nTratamiento"),
              ],
            ),
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
            Navigator.push(
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

  Widget _buildDashboardCard({required IconData icon, required String title, required String value}) {
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
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem({required IconData icon, required String text, required String time}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.amber[800]),
        title: Text(text, style: const TextStyle(fontSize: 15)),
        trailing: Text(time, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue[600],
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 6),
        Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
