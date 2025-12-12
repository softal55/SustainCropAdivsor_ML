import 'package:crop_recommendation/app/controllers/prediction_controller.dart';
import 'package:crop_recommendation/app/models/field.dart';
import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:crop_recommendation/app/utils/date_formater.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PredictionHistoryTab extends StatelessWidget {
  final PredictionController _predictionController =
      Get.find<PredictionController>();
  final Field field;
  PredictionHistoryTab({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_predictionController.predictions.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.history, size: 80, color: AppColors.secondary),
              SizedBox(height: 16),
              Text(
                'No predictions have been made yet.',
                style: TextStyle(fontSize: 18, color: AppColors.secondary),
              ),
            ],
          ),
        );
      } else {
        final reversedPredictions =
            _predictionController.predictions.reversed.toList();
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: reversedPredictions.length,
          itemBuilder: (context, index) {
            final prediction = reversedPredictions[index];
            return Card(
              color: AppColors.background,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ExpansionTile(
                backgroundColor: AppColors.background,
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/crops/${prediction.cropName}.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  prediction.cropName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                subtitle: Text(formatDate(prediction.predictionDate!)),
                trailing: Text(
                  '${(prediction.confidence * 100).toStringAsFixed(2)}%',
                  style: const TextStyle(fontSize: 16),
                ),
                children:
                    prediction.measurements!.map((measurement) {
                      return Card(
                        color: AppColors.background,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ExpansionTile(
                          backgroundColor: AppColors.background,
                          title: Text(
                            'Measurement ${prediction.measurements!.indexOf(measurement) + 1}',
                          ),

                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nitrogen (N): ${measurement.n}'),
                                    Text('Phosphorus (P): ${measurement.p}'),
                                    Text('Potassium (K): ${measurement.k}'),
                                    Text('pH Level: ${measurement.ph}'),
                                    Text(
                                      'Rainfall: ${measurement.rainfall} mm',
                                    ),
                                    Text(
                                      'Temperature: ${measurement.temperature} °C',
                                    ),
                                    Text('Humidity: ${measurement.humidity} %'),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            );
          },
        );
      }
    });
  }
}
