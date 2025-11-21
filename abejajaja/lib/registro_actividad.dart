import 'package:flutter/material.dart';

class RegistroActividadPage extends StatefulWidget {
  final String colmenaId;
  final String tipoActividad; // "tratamiento", "alimentacion", o "revision"

  const RegistroActividadPage({
    super.key,
    required this.colmenaId,
    required this.tipoActividad,
  });

  @override
  State<RegistroActividadPage> createState() => _RegistroActividadPageState();
}

class _RegistroActividadPageState extends State<RegistroActividadPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _fechaSeleccionada;
  String? _tipoTratamiento;
  String? _tipoAlimentacion;
  final TextEditingController _dosisController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();
  final TextEditingController _notasController = TextEditingController();
  bool _generarAlerta = false;
  DateTime? _fechaAlerta;

  final List<String> _tiposTratamiento = [
    'Apivar',
    'Ácido fórmico',
    'Ácido oxálico',
    'Apistan',
    'Timol',
    'Otro',
  ];

  final List<String> _tiposAlimentacion = [
    'Jarabe de azúcar',
    'Jarabe nutritivo',
    'Candy board',
    'Miel',
    'Alimentación terapéutica',
    'Otro',
  ];

  @override
  void dispose() {
    _dosisController.dispose();
    _cantidadController.dispose();
    _observacionesController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null && picked != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  Future<void> _seleccionarFechaAlerta(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null && picked != _fechaAlerta) {
      setState(() {
        _fechaAlerta = picked;
      });
    }
  }

  String _getTitulo() {
    switch (widget.tipoActividad.toLowerCase()) {
      case 'tratamiento':
        return 'Registrar Tratamiento';
      case 'alimentacion':
        return 'Registrar Alimentación';
      case 'revision':
        return 'Registrar Revisión';
      default:
        return 'Registrar Actividad';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool esTratamiento = widget.tipoActividad.toLowerCase() == 'tratamiento';
    final bool esAlimentacion = widget.tipoActividad.toLowerCase() == 'alimentacion';
    final bool esRevision = widget.tipoActividad.toLowerCase() == 'revision';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          _getTitulo(),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Información de Colmena ----
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.hive, color: Colors.amber),
                  title: const Text(
                    'Colmena',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  subtitle: Text(
                    widget.colmenaId,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ---- Fecha ----
              const Text(
                'Fecha',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.amber),
                  title: Text(
                    _fechaSeleccionada == null
                        ? 'Seleccionar fecha'
                        : '${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}',
                    style: TextStyle(
                      color: _fechaSeleccionada == null
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _seleccionarFecha(context),
                ),
              ),

              const SizedBox(height: 24),

              // ---- Tipo de Tratamiento (solo para tratamientos) ----
              if (esTratamiento) ...[
                const Text(
                  'Tipo de Tratamiento',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _tipoTratamiento,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      prefixIcon: Icon(Icons.vaccines, color: Colors.amber),
                    ),
                    hint: const Text('Seleccionar tipo de tratamiento'),
                    items: _tiposTratamiento.map((String tipo) {
                      return DropdownMenuItem<String>(
                        value: tipo,
                        child: Text(tipo),
                      );
                    }).toList(),
                    onChanged: (String? nuevoValor) {
                      setState(() {
                        _tipoTratamiento = nuevoValor;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona un tipo de tratamiento';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ---- Tipo de Alimentación (solo para alimentaciones) ----
              if (esAlimentacion) ...[
                const Text(
                  'Tipo de Alimentación',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _tipoAlimentacion,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      prefixIcon: Icon(Icons.restaurant, color: Colors.amber),
                    ),
                    hint: const Text('Seleccionar tipo de alimentación'),
                    items: _tiposAlimentacion.map((String tipo) {
                      return DropdownMenuItem<String>(
                        value: tipo,
                        child: Text(tipo),
                      );
                    }).toList(),
                    onChanged: (String? nuevoValor) {
                      setState(() {
                        _tipoAlimentacion = nuevoValor;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona un tipo de alimentación';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ---- Dosis (solo para tratamientos) ----
              if (esTratamiento) ...[
                const Text(
                  'Dosis',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: _dosisController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                      hintText: 'Ej: 1 tira, 50ml, 2 comprimidos',
                      prefixIcon: Icon(Icons.science, color: Colors.amber),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa la dosis';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ---- Cantidad (solo para alimentaciones) ----
              if (esAlimentacion) ...[
                const Text(
                  'Cantidad',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                      hintText: 'Ej: 2 litros, 500g',
                      prefixIcon: Icon(Icons.scale, color: Colors.amber),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa la cantidad';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ---- Observaciones ----
              const Text(
                'Observaciones',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: _observacionesController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    hintText: 'Escribe observaciones adicionales...',
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ---- Adjuntar Fotos o Notas ----
              const Text(
                'Adjuntar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Funcionalidad de adjuntar foto (prototipo)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Función de adjuntar foto (prototipo)'),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(Icons.photo_camera, size: 32, color: Colors.amber),
                              SizedBox(height: 8),
                              Text(
                                'Fotos',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Funcionalidad de adjuntar notas (prototipo)
                          _mostrarDialogoNotas(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Icon(Icons.note_add, size: 32, color: Colors.amber),
                              const SizedBox(height: 8),
                              const Text(
                                'Notas',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ---- Generar Alerta (solo para tratamientos) ----
              if (esTratamiento) ...[
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    title: const Text(
                      'Generar alerta para próximo tratamiento',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: _generarAlerta && _fechaAlerta != null
                        ? Text(
                            'Fecha recordatorio: ${_fechaAlerta!.day}/${_fechaAlerta!.month}/${_fechaAlerta!.year}',
                          )
                        : null,
                    secondary: const Icon(Icons.notifications_active, color: Colors.amber),
                    value: _generarAlerta,
                    onChanged: (bool value) {
                      setState(() {
                        _generarAlerta = value;
                        if (value) {
                          _seleccionarFechaAlerta(context);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ---- Botón de Guardar ----
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _fechaSeleccionada != null) {
                      // Prototipo - solo muestra mensaje
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${_getTitulo()} registrado correctamente'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      Navigator.pop(context);
                    } else if (_fechaSeleccionada == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor selecciona una fecha'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoNotas(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Nota'),
          content: TextField(
            controller: _notasController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Escribe tu nota aquí...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (_notasController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nota agregada (prototipo)'),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}

