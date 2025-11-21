import 'package:abejajaja/dashboard.dart';
import 'package:flutter/material.dart';

class ColmenasPage extends StatelessWidget {
  const ColmenasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Colmenas",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Icon(Icons.search, color: Colors.black87),
          SizedBox(width: 16),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[700],
        onPressed: null, // sin funcionalidad
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---- Chips de filtro ----
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterChip("Todas", true),
                  _buildFilterChip("Activas", false),
                  _buildFilterChip("En revisión", false),
                  _buildFilterChip("Con problemas", false),
                  _buildFilterChip("Tratamientos", false),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---- Lista de colmenas ----
            Expanded(
              child: ListView(
                children: [
                  _buildHiveCard(
                    number: "Colmena #1",
                    status: "Saludable",
                    lastReview: "Hace 5 días",
                    color: Colors.green,
                  ),
                  _buildHiveCard(
                    number: "Colmena #2",
                    status: "En revisión",
                    lastReview: "Ayer",
                    color: Colors.amber,
                  ),
                  _buildHiveCard(
                    number: "Colmena #3",
                    status: "Problema detectado",
                    lastReview: "Hace 10 días",
                    color: Colors.red,
                  ),
                  _buildHiveCard(
                    number: "Colmena #4",
                    status: "Tratamiento activo",
                    lastReview: "Hoy",
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DashboardPage()),
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

  // ---------------------
  // Widgets reutilizables
  // ---------------------

  Widget _buildFilterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: null, // disabled (sin funcionalidad)
        selectedColor: Colors.blue[600],
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildHiveCard({
    required String number,
    required String status,
    required String lastReview,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.hive, color: color, size: 26),
        ),
        title: Text(
          number,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(status, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(
              "Última revisión: $lastReview",
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
