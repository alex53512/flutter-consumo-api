import 'package:flutter/material.dart';
import '../alquilercontroller.dart';
import '../controllers/autoscontroller.dart';

class AlquileresScreen extends StatefulWidget {
  const AlquileresScreen({super.key});

  @override
  State<AlquileresScreen> createState() => _AlquileresScreenState();
}

class _AlquileresScreenState extends State<AlquileresScreen> {
  final AlquilerController _alquilerCtrl = AlquilerController();
  final AutosController _autosCtrl = AutosController();
  List<Map<String, dynamic>> _alquileres = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _loading = true);
    final data = await _alquilerCtrl.obtenerAlquileres();
    setState(() {
      _alquileres = data;
      _loading = false;
    });
  }

  Future<void> _devolver(int autoId, int alquilerId) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Devolver Vehículo'),
        content:
            const Text('¿Deseas marcar este vehículo como disponible?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Devolver',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final ok = await _autosCtrl.devolverAuto(autoId);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? '✅ Vehículo devuelto correctamente'
            : '❌ Error al devolver el vehículo'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );

    if (ok) _cargar();
  }

  String _formatFecha(String? fecha) {
    if (fecha == null) return 'N/A';
    try {
      final dt = DateTime.parse(fecha);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alquileres Activos'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _cargar),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _alquileres.isEmpty
              ? const Center(
                  child: Text('No hay alquileres registrados',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _alquileres.length,
                  itemBuilder: (context, index) {
                    final a = _alquileres[index];
                    final cliente = a['clientes'] ?? a['cliente'] ?? {};
                    final auto = a['autos'] ?? a['auto'] ?? {};
                    final autoId = auto['id'] ?? a['autoId'];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.receipt_long,
                                    color: Colors.indigo),
                                const SizedBox(width: 8),
                                Text(
                                  'Alquiler #${a['id']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                const Icon(Icons.person,
                                    size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '${cliente['nombre'] ?? 'N/A'}  •  ${cliente['correo'] ?? ''}',
                                    style:
                                        const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.directions_car,
                                    size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  '${auto['marca'] ?? ''} ${auto['modelo'] ?? ''}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.date_range,
                                    size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  '${_formatFecha(a['fechaInicio'])} → ${_formatFecha(a['fechaFin'])}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: autoId != null
                                    ? () => _devolver(autoId, a['id'])
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.assignment_return,
                                    size: 18),
                                label: const Text('Devolver'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
