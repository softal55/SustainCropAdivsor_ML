class Prediction {
  final int id;
  final int fieldId;
  final String cropName;
  final double confidence;
  final DateTime? predictionDate;
  final List<PredictionMeasurement>? measurements;

  Prediction({
    required this.id,
    required this.fieldId,
    required this.cropName,
    required this.confidence,
    this.predictionDate,
    this.measurements,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      id: json['id'] ?? 0,
      fieldId: json['field_id'] ?? 0,
      cropName: json['crop_name'],
      confidence: json['confidence'].toDouble(),
      predictionDate:
          json['prediction_date'] != null
              ? DateTime.parse(json['prediction_date'])
              : null,
      measurements:
          json['measurements'] != null
              ? (json['measurements'] as List)
                  .map((m) => PredictionMeasurement.fromJson(m))
                  .toList()
              : null,
    );
  }
}

class PredictionMeasurement {
  final double n;
  final double p;
  final double k;
  final double ph;
  final double rainfall;
  final double temperature;
  final double humidity;

  PredictionMeasurement({
    required this.n,
    required this.p,
    required this.k,
    required this.ph,
    required this.rainfall,
    required this.temperature,
    required this.humidity,
  });

  factory PredictionMeasurement.fromJson(Map<String, dynamic> json) {
    return PredictionMeasurement(
      n: json['n'].toDouble(),
      p: json['p'].toDouble(),
      k: json['k'].toDouble(),
      ph: json['ph'].toDouble(),
      rainfall: json['rainfall'].toDouble(),
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'n': n,
      'p': p,
      'k': k,
      'ph': ph,
      'rainfall': rainfall,
      'temperature': temperature,
      'humidity': humidity,
    };
  }
}
