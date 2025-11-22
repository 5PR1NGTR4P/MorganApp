import 'package:abejajaja/dashboard.dart';
import 'package:abejajaja/detalle_colmena.dart';
import 'package:flutter/material.dart';
import 'package:abejajaja/cosecha.dart';


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
        onPressed: null, // Lógica para agregar nueva colmena
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
                  _construirFiltroChip("Todas", true),
                  _construirFiltroChip("Activas", false),
                  _construirFiltroChip("En revisión", false),
                  _construirFiltroChip("Con problemas", false),
                  _construirFiltroChip("Tratamientos", false),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---- Lista de colmenas  ----
            Expanded(
              child: ListView(
                children: [
                  _buildHiveCard(
                    context,
                    number: "Colmena #1",
                    status: "Saludable",
                    lastReview: "Hace 5 días",
                    color: Colors.green,
                  ),
                  _buildHiveCard(
                    context,
                    number: "Colmena #2",
                    status: "En revisión",
                    lastReview: "Ayer",
                    color: Colors.amber,
                  ),
                  _buildHiveCard(
                    context,
                    number: "Colmena #3",
                    status: "Problema detectado",
                    lastReview: "Hace 10 días",
                    color: Colors.red,
                  ),
                  _buildHiveCard(
                    context,
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
        currentIndex: 1,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
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

  // -----------------------------------------------------------------------------------------
  // FUNCIÓN: Muestra el modal de opciones (AHORA RECIBE STATUS Y COLOR)
  // -----------------------------------------------------------------------------------------
  void _mostrarOpcionesColmena(
      BuildContext contexto,
      String numeroColmena,
      String status, // <-- NUEVO
      Color color // <-- NUEVO
      ) {
    showModalBottomSheet(
      context: contexto,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              // Opción de Cosecha
              ListTile(
                leading: const Icon(Icons.inventory_2_outlined, color: Colors.amber),
                title: const Text('Registrar Cosecha/Producción'),
                onTap: () => {
                  Navigator.pop(bc),
                  Navigator.push(contexto, MaterialPageRoute(
                      builder: (_) => cosecha(numeroColmena: numeroColmena)),
                  ),
                },
              ),
              // Opción de Detalle Histórico (PASA STATUS Y COLOR)
              ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Ver Histórico Completo'),
                  onTap: () => {
                    Navigator.pop(bc),
                    Navigator.push(contexto, MaterialPageRoute(
                      builder: (context) => DetalleColmenaPage(
                          colmenaId: numeroColmena,
                          status: status, // <-- PASANDO STATUS
                          statusColor: color // <-- PASANDO COLOR
                      ),
                    )),
                  }
              ),
            ],
          ),
        );
      },
    );
  }
  // -----------------------------------------------------------------------------------------


  Widget _construirFiltroChip(String etiqueta, bool seleccionado) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(etiqueta),
        selected: seleccionado,
        onSelected: (val) {},
        selectedColor: Colors.blue[600],
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: seleccionado ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildHiveCard(
      BuildContext context, {
        required String number,
        required String status,
        required String lastReview,
        required Color color,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: InkWell(
        // LLAMA A LA FUNCIÓN CON LOS NUEVOS PARÁMETROS DE STATUS Y COLOR
        onTap: () {
          _mostrarOpcionesColmena(context, number, status, color);
        },
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
      ),
    );
  }
}