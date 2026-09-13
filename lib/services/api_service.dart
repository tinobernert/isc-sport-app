import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 10.0.2.2 ist die IP, mit der der Android-Emulator deinen PC erreicht!
  static const String baseUrl = 'http://10.0.2.2/isc-sport-app-be/api';

  static Future<List<dynamic>> fetchClasses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_classes.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 'success') {
          return body['data'];
        }
      }
      throw Exception('Fehler beim Laden der Klassen');
    } catch (e) {
      throw Exception('Netzwerkfehler: $e');
    }
  }

  static Future<List<dynamic>> fetchTeachers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_teachers.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 'success') {
          return body['data']; // Gibt die Liste der Lehrer-Objekte [{"id": 1, "name": "..."}, ...] zurück
        }
      }
      throw Exception('Fehler beim Laden der Lehrer');
    } catch (e) {
      throw Exception('Netzwerkfehler: $e');
    }
  }
}