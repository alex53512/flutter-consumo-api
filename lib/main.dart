import 'package:flutter/material.dart';
import 'package:flutter_consumo_api/controllers/autoscontroller.dart';
import 'package:flutter_consumo_api/clientescontroller.dart';
import 'package:flutter_consumo_api/alquilercontroller.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final autosController = AutosController();
  final clientesController = ClientesController(); 
  final alquilerController = AlquilerController(); 

  print('========== PRUEBA DE API AUTOS ==========');

  final autos = await autosController.obtenerAutosDisponibles();

  print('Resultado final retornado al main: ${autos.length} vehículos');
  print('=========================================');

  
  print('========== PRUEBA DE API CLIENTES ==========');
  final clientes = await clientesController.obtenerClientes();
  print('Resultado clientes: ${clientes.length}');
  print('===========================================');

  
  print('========== PRUEBA DE API ALQUILER ==========');
  final alquiler = await alquilerController.obtenerAlquileres();
  print('Resultado alquiler: ${alquiler.length}');
  print('===========================================');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Text('Consumo de API Alquiler Autos'),
      ),
    );
  }
}
