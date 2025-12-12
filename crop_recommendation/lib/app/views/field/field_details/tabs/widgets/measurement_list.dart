import 'package:crop_recommendation/app/views/field/field_details/tabs/widgets/measurement_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crop_recommendation/app/controllers/measurement_controller.dart';
import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:crop_recommendation/app/utils/date_formater.dart';

class MeasurementList extends StatelessWidget {
  final MeasurementController controller;

  const MeasurementList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final measurements = controller.measurements;
      if (measurements.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.analytics, color: AppColors.secondary, size: 50),
              SizedBox(height: 10),
              Text(
                'No measurements are taken yet',
                style: TextStyle(fontSize: 16, color: AppColors.secondary),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: measurements.length,
        itemBuilder: (context, index) {
          final measurement = measurements[index];
          return GestureDetector(
            onLongPress:
                () => showMeasurementOptions(context, measurement, controller),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              color: AppColors.background,
              child: ExpansionTile(
                backgroundColor: AppColors.background,
                title: Text('Measurement ${index + 1}'),
                subtitle: Text(formatDate(measurement.measurementDate!)),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Latitude: ${measurement.point.latitude}'),
                          Text('Longitude: ${measurement.point.longitude}'),
                          Text('Nitrogen (N): ${measurement.n}'),
                          Text('Phosphorus (P): ${measurement.p}'),
                          Text('Potassium (K): ${measurement.k}'),
                          Text('pH Level: ${measurement.ph}'),
                          Text('Rainfall: ${measurement.rainfall} mm'),
                          Text('Temperature: ${measurement.temperature} °C'),
                          Text('Humidity: ${measurement.humidity} %'),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
