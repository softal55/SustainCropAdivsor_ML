import 'package:crop_recommendation/app/controllers/fields_controller.dart';
import 'package:crop_recommendation/app/controllers/measurement_controller.dart';
import 'package:crop_recommendation/app/controllers/prediction_controller.dart';
import 'package:crop_recommendation/app/models/field.dart';
import 'package:crop_recommendation/app/models/prediction.dart';
import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'tabs/field_map_tab.dart';
import 'tabs/measurement_tab.dart';
import 'tabs/prediction_history_tab.dart';

class FieldDetailsView extends StatelessWidget {
  final FieldController fieldController = Get.find<FieldController>();
  final MeasurementController measurementsController =
      Get.find<MeasurementController>();
  final PredictionController predictionController =
      Get.find<PredictionController>();

  FieldDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Field field = Get.arguments;

    measurementsController.fetchMeasurements(field.id);
    predictionController.fetchPredictions(field.id);

    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => _buildHeader(field, predictionController.predictions),
                ),
                const Divider(),
                const TabBar(
                  indicatorColor: AppColors.primary,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.satellite_alt,
                        color: AppColors.secondary,
                      ),
                    ),
                    Tab(
                      icon: Icon(Icons.analytics, color: AppColors.secondary),
                    ),
                    Tab(icon: Icon(Icons.history, color: AppColors.secondary)),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      FieldMapTab(field: field),
                      MeasurementTab(field: field),
                      PredictionHistoryTab(field: field),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Field field, RxList<Prediction> predictions) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                field.name,
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppColors.secondary,
                  size: 28,
                ),
                onPressed: () => Get.back(),
              ),
            ],
          ),

          Text(
            '${(field.area / 100).toStringAsFixed(2)} ac',
            style: const TextStyle(fontSize: 16, color: AppColors.secondary),
          ),
          predictions.isEmpty
              ? const SizedBox()
              : Text(
                '${predictions.last.cropName} ${(predictions.last.confidence * 100).toStringAsFixed(2)}%',
                style: const TextStyle(color: AppColors.primary, fontSize: 16),
              ),
        ],
      ),
    );
  }
}
