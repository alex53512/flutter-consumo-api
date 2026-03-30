import 'dart:convert';
import 'package:http/http.dart' as http;

class AlquilerController {
  final String baseUrl = 'http://localhost:6001/api/alquiler';

  Future<List<Map<String, dynamic>>> obtenerAlquileres() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      print('--- ALQUILER ---');
      print(response.body);

      final List data = jsonDecode(response.body);

      final alquiler = data.map<Map<String, dynamic>>((a) {
        return Map<String, dynamic>.from(a);
      }).toList();

      // 👇 MOSTRAR BONITO
      print('--- RECORRIDO DE ALQUILER ---');
      for (int i = 0; i < alquiler.length; i++) {
        final a = alquiler[i];

        print('Alquiler #${i + 1}');
        print('id: ${a['id']}');
        print('fechaInicio: ${a['fechaInicio']}');
        print('fechaFin: ${a['fechaFin']}');

        print('--- CLIENTE ---');
        print('nombre: ${a['clientes']['nombre']}');
        print('correo: ${a['clientes']['correo']}');

        print('--- AUTO ---');
        print('marca: ${a['autos']['marca']}');
        print('modelo: ${a['autos']['modelo']}');

        print('-----------------------------');
      }

      return alquiler;
    } catch (e) {
      print('Error alquiler: $e');
      return [];
    }
  }
}