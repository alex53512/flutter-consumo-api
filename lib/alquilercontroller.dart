import 'dart:convert';
import 'package:http/http.dart' as http;

class AlquilerController {
  final String baseUrl =
      'https://backend-alquiler-autos-pezh.onrender.com/api/alquiler';

  Future<List<Map<String, dynamic>>> obtenerAlquileres() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode != 200) return [];
      final List data = jsonDecode(response.body);
      return data.map<Map<String, dynamic>>((a) => Map<String, dynamic>.from(a)).toList();
    } catch (e) {
      print('Error alquiler: $e');
      return [];
    }
  }
}
