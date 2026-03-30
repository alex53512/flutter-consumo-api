import 'dart:convert';
import 'package:http/http.dart' as http;

class ClientesController {
  final String baseUrl = 'http://localhost:6001/api/clientes';

  Future<List<Map<String, dynamic>>> obtenerClientes() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      print('--- CLIENTES ---');
      print(response.body);

      final decoded = jsonDecode(response.body);

      // 👇 CORRECCIÓN AQUÍ
      if (decoded is Map<String, dynamic> && decoded['clientes'] is List) {
        final List data = decoded['clientes'];

        final clientes = data.map<Map<String, dynamic>>((c) {
          return Map<String, dynamic>.from(c);
        }).toList();

        // 👇 MOSTRAR BONITO
        print('--- RECORRIDO DE CLIENTES ---');
        for (int i = 0; i < clientes.length; i++) {
          final cliente = clientes[i];

          print('Cliente #${i + 1}');
          print('id: ${cliente['id']}');
          print('nombre: ${cliente['nombre']}');
          print('correo: ${cliente['correo']}');
          print('numLic: ${cliente['numLic']}');
          print('-----------------------------');
        }

        return clientes;
      }

      return [];
    } catch (e) {
      print('Error clientes: $e');
      return [];
    }
  }
}