import 'package:crop_recommendation/app/views/field/field_details/tabs/widgets/measurement_dialog.dart';
import 'package:flutter/material.dart';
import 'package:crop_recommendation/app/controllers/measurement_controller.dart';
import 'package:crop_recommendation/app/models/measurement.dart';
import 'package:crop_recommendation/app/utils/app_colors.dart';

void showMeasurementOptions(
  BuildContext context,
  Measurement measurement,
  MeasurementController controller,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.background,
    builder:
        (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: AppColors.primary),
                title: const Text('Edit Measurement'),
                onTap: () {
                  Navigator.pop(context);
                  showEditMeasurementDialog(context, measurement, controller);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete Measurement',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.deleteMeasurement(measurement);
                },
              ),
            ],
          ),
        ),
  );
}
