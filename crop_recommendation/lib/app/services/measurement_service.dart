import 'dart:convert';

import 'package:crop_recommendation/app/services/base_url.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class MeasurementService {
  final String _fieldsUrl = BaseUrl.fieldsUrl;

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${GetStorage().read('token')}',
  };
  Future<List<dynamic>> getMeasurements(int fieldId) async {
    try {
      final response = await http.get(
        Uri.parse('$_fieldsUrl/$fieldId/measurements'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load measurements');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<dynamic> addMeasurement({
    required int fieldId,
    required double n,
    required double p,
    required double k,
    required double ph,
    required double rainfall,
    required double temperature,
    required double humidity,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_fieldsUrl/$fieldId/measurements'),
        headers: headers,
        body: json.encode({
          'latitude': latitude,
          'longitude': longitude,
          'n': n,
          'p': p,
          'k': k,
          'ph': ph,
          'rainfall': rainfall,
          'temperature': temperature,
          'humidity': humidity,
        }),
      );
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add measurement: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<void> editMeasurement({
    required int measurementId,
    required double n,
    required double p,
    required double k,
    required double ph,
    required double rainfall,
    required double temperature,
    required double humidity,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_fieldsUrl/measurements/$measurementId'),
        headers: headers,
        body: json.encode({
          'n': n,
          'p': p,
          'k': k,
          'ph': ph,
          'rainfall': rainfall,
          'temperature': temperature,
          'humidity': humidity,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update measurement: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<void> deleteMeasurement(int measurementId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_fieldsUrl/measurements/$measurementId'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete measurement: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}
