import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class FlockService {
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000/api/flock';
    return 'http://10.0.2.2:8000/api/flock';
  }

  Future<List<Map<String, dynamic>>> getBreeds() async {
    final response = await http.get(Uri.parse('$baseUrl/breeds/'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load chicken breeds');
    }
  }

  Future<List<Map<String, dynamic>>> getFlocks() async {
    final response = await http.get(Uri.parse('$baseUrl/flocks/'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load flocks');
    }
  }
}
