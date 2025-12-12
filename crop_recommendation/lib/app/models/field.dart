import 'package:crop_recommendation/app/models/point.dart';
import 'package:crop_recommendation/app/models/prediction.dart' show Prediction;

class Field {
  final int id;
  final String name;
  final double area;
  final DateTime? creationDate;
  final List<Point> points;
  final List<Prediction>? predictions;

  Field({
    required this.id,
    required this.name,
    required this.area,
    this.creationDate,
    required this.points,
    this.predictions,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      name: json['name'],
      area: json['area'].toDouble(),
      creationDate: json['creation_date'] != null 
          ? DateTime.parse(json['creation_date'])
          : null,
      points: (json['points'] as List)
          .map((point) => Point.fromJson(point))
          .toList(),
      predictions: json['predictions'] != null
          ? (json['predictions'] as List)
              .map((pred) => Prediction.fromJson(pred))
              .toList()
          : null,
    );
  }
}