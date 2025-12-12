// app/controllers/prediction_controller.dart
import 'package:crop_recommendation/app/models/measurement.dart';
import 'package:crop_recommendation/app/models/prediction.dart';
import 'package:crop_recommendation/app/services/prediction_service.dart';
import 'package:crop_recommendation/app/views/shared/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PredictionController extends GetxController {
  final PredictionService _predictionService = PredictionService();
  var predictions =
      <Prediction>[].obs; // This will hold *saved* predictions for the field
  var temporaryPredictions =
      <Prediction>[]
          .obs; // This will hold predictions from a fresh 'makePrediction' call
  var isLoading = false.obs;

  Future<void> makePrediction(List<Measurement> measurements) async {
    isLoading.value = true;
    try {
      final measurementData =
          measurements
              .map(
                (e) => {
                  'n': e.n,
                  'p': e.p,
                  'k': e.k,
                  'temperature': e.temperature,
                  'humidity': e.humidity,
                  'ph': e.ph,
                  'rainfall': e.rainfall,
                },
              )
              .toList();

      final data = await _predictionService.makePrediction(measurementData);
      temporaryPredictions.value =
          data
              .map((e) => Prediction.fromJson(e))
              .toList(); // Populate temporary list
      // Do NOT populate 'predictions' here
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to fetch predictions: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPredictions(int fieldId) async {
    isLoading.value = true;
    try {
      final data = await _predictionService.getPredictions(fieldId);
      predictions.value =
          data
              .map((e) => Prediction.fromJson(e))
              .toList(); // Populate main predictions list
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to load predictions!',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPrediction({
    required int fieldId,
    required String cropName,
    required double confidence,
    required List<Measurement> measurements,
  }) async {
    isLoading.value = true;
    try {
      final measurementData =
          measurements
              .map(
                (e) => {
                  'n': e.n,
                  'p': e.p,
                  'k': e.k,
                  'temperature': e.temperature,
                  'humidity': e.humidity,
                  'ph': e.ph,
                  'rainfall': e.rainfall,
                },
              )
              .toList();

      await _predictionService.addPrediction(
        fieldId: fieldId,
        cropName: cropName,
        confidence: confidence,
        measurements: measurementData,
      );
      // After successfully adding a prediction, refresh the main predictions list
      await fetchPredictions(fieldId);
      showCustomSnackbar(
        title: 'Success',
        message: 'Prediction added successfully',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to add prediction: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
