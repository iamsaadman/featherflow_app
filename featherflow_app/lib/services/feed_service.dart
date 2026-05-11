import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class FeedService {
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000/api/feed';
    // For Android physical devices, use your computer's IP. For emulator:
    return 'http://10.0.2.2:8000/api/feed';
  }

  Future<List<Map<String, dynamic>>> getFeedStock() async {
    final response = await http.get(Uri.parse('$baseUrl/stock/'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load feed stock');
    }
  }

  Future<List<Map<String, dynamic>>> getFeedSchedules() async {
    final response = await http.get(Uri.parse('$baseUrl/schedules/'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load feed schedules');
    }
  }

  Future<List<Map<String, dynamic>>> getFeedNutritionPlans() async {
    final response = await http.get(Uri.parse('$baseUrl/nutrition/'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load nutrition plans');
    }
  }

  Future<List<Map<String, dynamic>>> getFeedTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/types/'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load feed types');
    }
  }

  Future<List<Map<String, dynamic>>> getFeedConsumptionLogs() async {
    final response = await http.get(Uri.parse('$baseUrl/consumption/'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load consumption logs');
    }
  }

  Future<List<Map<String, dynamic>>> getFeedPurchaseOrders() async {
    final response = await http.get(Uri.parse('$baseUrl/purchases/'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load purchase orders');
    }
  }

  Future<void> updateScheduleStatus(int id, bool isDone) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/schedules/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'is_done': isDone}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update schedule');
    }
  }

  Future<void> addFeedConsumptionLog(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/consumption/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create consumption log');
    }
  }

  Future<void> createFeedType(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/types/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create feed type');
    }
  }

  Future<void> createFeedStock(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/stock/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create feed stock');
    }
  }

  Future<void> createFeedSchedule(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/schedules/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create feed schedule');
    }
  }

  Future<void> createFeedNutritionPlan(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/nutrition/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create nutrition plan');
    }
  }

  Future<void> createFeedPurchaseOrder(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/purchases/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create purchase order');
    }
  }
}
