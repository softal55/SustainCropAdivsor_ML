// app/views/field/field_details/tabs/measurement_tab.dart
import 'package:crop_recommendation/app/controllers/prediction_controller.dart';
import 'package:crop_recommendation/app/views/field/field_details/tabs/widgets/measurement_dialog.dart';
import 'package:crop_recommendation/app/views/field/field_details/tabs/widgets/measurement_list.dart';
import 'package:crop_recommendation/app/views/shared/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crop_recommendation/app/controllers/measurement_controller.dart';
import 'package:crop_recommendation/app/models/field.dart';
import 'package:crop_recommendation/app/utils/app_colors.dart';

class MeasurementTab extends StatelessWidget {
  final MeasurementController measurementsController =
      Get.find<MeasurementController>();
  final PredictionController predictionController =
      Get.find<PredictionController>();
  final Field field;

  MeasurementTab({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Measurements',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColors.primary),
                    onPressed:
                        () => showAddMeasurementDialog(
                          context,
                          field,
                          measurementsController,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MeasurementList(controller: measurementsController),
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Obx(() {
            return FloatingActionButton.extended(
              backgroundColor:
                  measurementsController.measurements.isNotEmpty
                      ? AppColors.primary
                      : Colors.grey,
              foregroundColor: Colors.white,
              onPressed:
                  measurementsController.measurements.isNotEmpty
                      ? () async {
                        // Clear previous temporary predictions before making a new one
                        predictionController.temporaryPredictions.clear();
                        await predictionController.makePrediction(
                          measurementsController.measurements,
                        );

                        // Handle the prediction result from temporaryPredictions
                        if (predictionController
                            .temporaryPredictions
                            .isNotEmpty) {
                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: AppColors.background,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Column(
                                  children: [
                                    Text(
                                      'Choose a crop',
                                      style: TextStyle(
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (predictionController
                                        .predictions
                                        .isNotEmpty)
                                      Text(
                                        'last chosen crop : ${predictionController.predictions.last.cropName}',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 18,
                                        ),
                                      ),
                                  ],
                                ),
                                content: SizedBox(
                                  height: 300,
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    itemCount:
                                        predictionController
                                            .temporaryPredictions
                                            .length,
                                    itemBuilder: (context, index) {
                                      final prediction =
                                          predictionController
                                              .temporaryPredictions[index];
                                      return ListTile(
                                        leading: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'assets/images/crops/${prediction.cropName}.jpg',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        title: Text(prediction.cropName),
                                        subtitle: Text(
                                          'Confidence: ${prediction.confidence.toStringAsFixed(2)}',
                                        ),
                                        onTap: () async {
                                          final confirm = await showDialog<
                                            bool
                                          >(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  backgroundColor:
                                                      AppColors.background,
                                                  title: const Text(
                                                    'Confirm Selection',
                                                  ),
                                                  content: Text(
                                                    'Do you want to add "${prediction.cropName}" to this field?',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                            foregroundColor:
                                                                AppColors.error,
                                                          ),
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                            false,
                                                          ),
                                                      child: const Text(
                                                        'Cancel',
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                            foregroundColor:
                                                                AppColors
                                                                    .primary,
                                                            backgroundColor:
                                                                AppColors
                                                                    .background,
                                                          ),
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                            true,
                                                          ),
                                                      child: const Text(
                                                        'Confirm',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );

                                          if (confirm == true) {
                                            await predictionController
                                                .addPrediction(
                                                  fieldId: field.id,
                                                  cropName: prediction.cropName,
                                                  confidence:
                                                      prediction.confidence,
                                                  measurements:
                                                      measurementsController
                                                          .measurements,
                                                );
                                            Navigator.pop(
                                              // ignore: use_build_context_synchronously
                                              context,
                                            ); // Close the crop selection dialog
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          showCustomSnackbar(
                            title: 'No Crops Recommended',
                            message:
                                'No suitable crops were found for this field.',
                            backgroundColor: Colors.orange,
                          );
                        }
                      }
                      : null,
              label:
                  predictionController.isLoading.value
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text('Start Prediction'),
              icon:
                  predictionController.isLoading.value
                      ? const SizedBox.shrink()
                      : const Icon(Icons.psychology),
            );
          }),
        ),
      ],
    );
  }
}
