// Sirve para convertir texto JSON en estructuras de Dart
import 'dart:convert';

// Paquete para hacer peticiones HTTP al backend
import 'package:http/http.dart' as http;

/// Controller simple para practicar el consumo de API sin interfaz.

class AutosController {
  /// URL real de tu backend para obtener los autos disponibles
  //final String baseUrl = 'https://bakendalquilerautos.onrender.com/api/autos&#39;;
 //ESCRIBIR ESTA LINEA COMENTADA EN LA URL A CONECTARSE
//  final String baseUrl = http://localhost:6001/api/autos;
  //final String baseUrl = 'https://flutter30654746.onrender.com/api/autos';
final String baseUrl ='http://localhost:6001/api/autos';
  /// Método Future porque el resultado no llega de inmediato:
 
  Future<List<Map<String, dynamic>>> obtenerAutosDisponibles() async {
    try {
      // 1) Convertimos la URL String en un objeto Uri
      final url = Uri.parse(baseUrl);

      // 2) Imprimimos en consola qué URL se va a consultar
      print('--- INICIO DE PETICION ---');
      print('URL consultada: $url');

      // 3) Hacemos la petición GET y esperamos la respuesta
      final response = await http.get(url);

      // 4) Mostramos en consola información importante de la respuesta
      print('Status code recibido: ${response.statusCode}');
      print('Body recibido desde la API:');
      print(response.body);

      // 5) Validamos que el servidor haya respondido correctamente
      if (response.statusCode != 200) {
        throw Exception(
          'Error al obtener los vehículos. Código HTTP: ${response.statusCode}',
        );
      }

      // 6) Convertimos el JSON (texto) en una estructura de Dart
      final decoded = jsonDecode(response.body);

      // 7) Mostramos en consola qué tipo de dato produjo jsonDecode
      print('Tipo de dato luego de jsonDecode: ${decoded.runtimeType}');

      // 8) Aquí prepararemos una lista genérica para terminar
      // convirtiéndola en List<Map<String, dynamic>>
      late final List data;

      // 9) Caso más común en tu backend actual:
      // la API devuelve directamente una lista de autos
      if (decoded is List) {
        data = decoded;
      }
      // 10) Caso alternativo:
      // si alguna vez la API devuelve un Map envolviendo la lista
      else if (decoded is Map<String, dynamic>) {
        if (decoded['autos'] is List) {
          data = decoded['autos'] as List;
        } else if (decoded['data'] is List) {
          data = decoded['data'] as List;
        } else {
          // Si viniera un solo objeto, lo metemos dentro de una lista
          data = [decoded];
        }
      } else {
        throw Exception(
          'Formato inesperado de la respuesta: ${decoded.runtimeType}',
        );
      }

      print('Cantidad de elementos recibidos: ${data.length}');

      // 11) Convertimos cada elemento a Map<String, dynamic>
      final List<Map<String, dynamic>> autos = data.map<Map<String, dynamic>>((auto) {
        return Map<String, dynamic>.from(auto);
      }).toList();

      // 12) Recorremos la lista e imprimimos algunos campos importantes
      print('--- RECORRIDO DE VEHICULOS ---');
      for (int i = 0; i < autos.length; i++) {
        final vehiculo = autos[i];

        print('Vehiculo #${i + 1}');
        print('id: ${vehiculo['id']}');
        print('marca: ${vehiculo['marca']}');
        print('modelo: ${vehiculo['modelo']}');
        print('anio: ${vehiculo['anio']}');
        print('valorAlquiler: \$${vehiculo['valorAlquiler']}');
        print('disponibilidad: ${vehiculo['disponibilidad'] == 1 ? "Disponible" : "No disponible"}');   
        print('-----------------------------');
      }

      print('--- FIN DE PETICION EXITOSA ---');

      // 13) Retornamos la lista final
      return autos;
    } catch (e) {
      // 14) Si algo falla, lo mostramos en consola
      print('Error en obtenerAutosDisponibles: $e');

      // 15) Retornamos lista vacía para que el ejercicio no reviente
      return [];
    }
  }
}