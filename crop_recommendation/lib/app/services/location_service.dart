import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static const String _nominatimUrl =
      "https://nominatim.openstreetmap.org/search";

  Future<List<Map<String, dynamic>>> searchLocation(String query) async {
    final response = await http.get(
      Uri.parse("$_nominatimUrl?q=$query&format=json&addressdetails=1"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }
}
