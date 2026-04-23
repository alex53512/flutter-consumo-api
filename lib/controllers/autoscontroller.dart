import 'dart:convert';
import 'package:http/http.dart' as http;

class AutosController {
  final String baseUrl =
      'https://backend-alquiler-autos-pezh.onrender.com/api/autos';

  Future<List<Map<String, dynamic>>> obtenerAutosDisponibles() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode != 200) return [];
      final decoded = jsonDecode(response.body);
      late final List data;
      if (decoded is List) {
        data = decoded;
      } else if (decoded is Map<String, dynamic> && decoded['autos'] is List) {
        data = decoded['autos'] as List;
      } else {
        return [];
      }
      return data.map<Map<String, dynamic>>((a) => Map<String, dynamic>.from(a)).toList();
    } catch (e) {
      print('Error en obtenerAutosDisponibles: $e');
      return [];
    }
  }

  Future<bool> registrarAuto(Map<String, dynamic> datos) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(datos),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error al registrar auto: $e');
      return false;
    }
  }

  Future<bool> devolverAuto(int id) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id/devolver'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error al devolver auto: $e');
      return false;
    }
  }
}
