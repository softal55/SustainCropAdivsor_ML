class MockPrediction {
  final String crop;
  final double score;

  MockPrediction({required this.crop, required this.score});

  factory MockPrediction.fromJson(Map<String, dynamic> json) {
    return MockPrediction(
      crop: json['crop'],
      score: json['score']?.toDouble() ?? 0.0,
    );
  }
}