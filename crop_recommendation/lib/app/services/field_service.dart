import 'dart:convert';
import 'package:crop_recommendation/app/services/base_url.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class FieldService {
  final String _fieldsUrl = BaseUrl.fieldsUrl;

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${GetStorage().read('token')}',
  };

  Future<List<dynamic>> getUserFields() async {
    try {
      final response = await http.get(
        Uri.parse('$_fieldsUrl/'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        debugPrint(response.body);
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load fields');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<dynamic> addField({
    required String name,
    required double area,
    required List<Map<String, double>> points,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_fieldsUrl/'),
        headers: headers,
        body: json.encode({'name': name, 'area': area, 'points': points}),
      );
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add field: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<void> editField({
    required int fieldId,
    required String name,
    required double area,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_fieldsUrl/fields/$fieldId'),
        headers: headers,
        body: json.encode({'name': name, 'area': area}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update field: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<void> deleteField(int fieldId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_fieldsUrl/$fieldId'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete field: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

}
