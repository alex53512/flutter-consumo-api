import 'package:flutter/material.dart';
import '../controllers/autoscontroller.dart';

class AutosScreen extends StatefulWidget {
  const AutosScreen({super.key});

  @override
  State<AutosScreen> createState() => _AutosScreenState();
}

class _AutosScreenState extends State<AutosScreen> {
  final AutosController _controller = AutosController();
  List<Map<String, dynamic>> _autos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarAutos();
  }

  Future<void> _cargarAutos() async {
    setState(() => _loading = true);
    final autos = await _controller.obtenerAutosDisponibles();
    setState(() {
      _autos = autos;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehículos Disponibles'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarAutos,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _autos.isEmpty
              ? const Center(
                  child: Text(
                    'No hay vehículos disponibles',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _autos.length,
                  itemBuilder: (context, index) {
                    final auto = _autos[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo.shade100,
                          child: Icon(Icons.directions_car,
                              color: Colors.indigo.shade700),
                        ),
                        title: Text(
                          '${auto['marca']} ${auto['modelo']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Año: ${auto['anio']}  •  \$${auto['valorAlquiler']}/día',
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: auto['disponibilidad'] == 1
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            auto['disponibilidad'] == 1
                                ? 'Disponible'
                                : 'No disponible',
                            style: TextStyle(
                              color: auto['disponibilidad'] == 1
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
