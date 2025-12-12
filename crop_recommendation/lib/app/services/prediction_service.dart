import 'dart:convert';
import 'package:crop_recommendation/app/services/base_url.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class PredictionService {
  final String predictUrl = BaseUrl.predictUrl;
  final String baseUrl = BaseUrl.fieldsUrl;
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${GetStorage().read('token')}',
  };

  Future<List<Map<String, dynamic>>> makePrediction(
    List<Map<String, dynamic>> measurements,
  ) async {
    final url = Uri.parse('$predictUrl/recommend');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(measurements),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('recommendations')) {
          final recommendations = data['recommendations'] as List<dynamic>;

          // Transform to match the `Prediction` model structure.
          return recommendations.map((rec) {
            return {
              'id': 0, // Add placeholder values for missing fields.
              'field_id': 0,
              'crop_name': rec['crop_name'],
              'confidence': rec['confidence'],
              'prediction_date': null, // Default for optional fields.
              'prediction_measurement': null, // Default for optional fields.
            };
          }).toList();
        } else {
          throw Exception('Unexpected response format: $data');
        }
      } else {
        throw Exception(
          'Failed to fetch predictions. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error while fetching predictions: $e');
    }
  }

  Future<void> addPrediction({
    required int fieldId,
    required String cropName,
    required double confidence,
    required List<Map<String, dynamic>> measurements,
  }) async {
    final url = Uri.parse('$baseUrl/$fieldId/predictions');
    final body = {
      'crop_name': cropName,
      'confidence': confidence,
      'measurements': measurements,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode != 201) {
        throw Exception(
          'Failed to add prediction. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error adding prediction: $e');
    }
  }

  Future<List<dynamic>> getPredictions(int fieldId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$fieldId/predictions'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}
