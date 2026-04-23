import 'dart:convert';
import 'package:http/http.dart' as http;

class ClientesController {
  final String baseUrl =
      'https://backend-alquiler-autos-pezh.onrender.com/api/clientes';

  Future<List<Map<String, dynamic>>> obtenerClientes() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode != 200) return [];
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic> && decoded['clientes'] is List) {
        final List data = decoded['clientes'];
        return data.map<Map<String, dynamic>>((c) => Map<String, dynamic>.from(c)).toList();
      }
      if (decoded is List) {
        return decoded.map<Map<String, dynamic>>((c) => Map<String, dynamic>.from(c)).toList();
      }
      return [];
    } catch (e) {
      print('Error clientes: $e');
      return [];
    }
  }
}
