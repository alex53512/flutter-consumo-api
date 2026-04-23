import 'package:flutter/material.dart';
import '../controllers/autoscontroller.dart';

class RegistrarAutoScreen extends StatefulWidget {
  const RegistrarAutoScreen({super.key});

  @override
  State<RegistrarAutoScreen> createState() => _RegistrarAutoScreenState();
}

class _RegistrarAutoScreenState extends State<RegistrarAutoScreen> {
  final _formKey = GlobalKey<FormState>();
  final AutosController _controller = AutosController();

  final _marcaCtrl = TextEditingController();
  final _modeloCtrl = TextEditingController();
  final _imagenCtrl = TextEditingController();
  final _valorCtrl = TextEditingController();
  final _anioCtrl = TextEditingController();
  bool _enviando = false;

  @override
  void dispose() {
    _marcaCtrl.dispose();
    _modeloCtrl.dispose();
    _imagenCtrl.dispose();
    _valorCtrl.dispose();
    _anioCtrl.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _enviando = true);

    final datos = {
      'marca': _marcaCtrl.text.trim(),
      'modelo': _modeloCtrl.text.trim(),
      'imagen': _imagenCtrl.text.trim().isEmpty
          ? 'https://img.com/auto.jpg'
          : _imagenCtrl.text.trim(),
      'valorAlquiler': double.tryParse(_valorCtrl.text.trim()) ?? 0,
      'anio': _anioCtrl.text.trim(),
      'disponibilidad': 1,
    };

    final ok = await _controller.registrarAuto(datos);
    setState(() => _enviando = false);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Vehículo registrado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Error al registrar el vehículo'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _campo(
      TextEditingController ctrl, String label, IconData icon,
      {TextInputType tipo = TextInputType.text, bool requerido = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: ctrl,
        keyboardType: tipo,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.indigo),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
        ),
        validator: requerido
            ? (v) => (v == null || v.trim().isEmpty) ? 'Campo requerido' : null
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Vehículo'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.directions_car, size: 60, color: Colors.indigo),
              const SizedBox(height: 8),
              const Text(
                'Nuevo Vehículo',
                style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _campo(_marcaCtrl, 'Marca', Icons.branding_watermark),
              _campo(_modeloCtrl, 'Modelo', Icons.car_rental),
              _campo(_imagenCtrl, 'URL de imagen (opcional)', Icons.image,
                  requerido: false),
              _campo(_valorCtrl, 'Valor por día (\$)', Icons.attach_money,
                  tipo: TextInputType.number),
              _campo(_anioCtrl, 'Año', Icons.calendar_today,
                  tipo: TextInputType.number),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _enviando ? null : _registrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: _enviando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_enviando ? 'Guardando...' : 'Registrar Vehículo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
