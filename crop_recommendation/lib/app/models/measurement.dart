// measurement.dart
import 'package:crop_recommendation/app/models/point.dart';

class Measurement {
  final int id;
  final int fieldId;
  final Point point;
  final double n;
  final double p;
  final double k;
  final double ph;
  final double rainfall;
  final double temperature;
  final double humidity;
  final DateTime? measurementDate;

  Measurement({
    required this.id,
    required this.fieldId,
    required this.point,
    required this.n,
    required this.p,
    required this.k,
    required this.ph,
    required this.rainfall,
    required this.temperature,
    required this.humidity,
    this.measurementDate,
  });

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'],
      fieldId: json['field_id'],
      point: Point.fromJson(json['measurement_point']),
      n: json['n'].toDouble(),
      p: json['p'].toDouble(),
      k: json['k'].toDouble(),
      ph: json['ph'].toDouble(),
      rainfall: json['rainfall'].toDouble(),
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'].toDouble(),
      measurementDate:
          json['measurement_date'] != null
              ? DateTime.parse(json['measurement_date'])
              : null,
    );
  }
}
