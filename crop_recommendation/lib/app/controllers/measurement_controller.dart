import 'package:crop_recommendation/app/models/measurement.dart';
import 'package:crop_recommendation/app/services/measurement_service.dart';
import 'package:crop_recommendation/app/views/shared/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeasurementController extends GetxController {
  final MeasurementService _measurementService = MeasurementService();
  var measurements = <Measurement>[].obs;
  var isLoading = false.obs;
  var selectedFieldId = 0.obs;

  Future<void> fetchMeasurements(int fieldId) async {
    isLoading.value = true;
    selectedFieldId.value = fieldId;
    try {
      final data = await _measurementService.getMeasurements(fieldId);
      measurements.value = data.map((e) => Measurement.fromJson(e)).toList();
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to load measurements: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMeasurement(Measurement measurement) async {
    try {
      isLoading.value = true;
      await _measurementService.addMeasurement(
        fieldId: measurement.fieldId,
        latitude: measurement.point.latitude,
        longitude: measurement.point.longitude,
        n: measurement.n,
        p: measurement.p,
        k: measurement.k,
        ph: measurement.ph,
        rainfall: measurement.rainfall,
        temperature: measurement.temperature,
        humidity: measurement.humidity,
      );
      fetchMeasurements(measurement.fieldId);
      showCustomSnackbar(
        title: 'Success',
        message: 'Measurement added successfully',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to add measurement: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editMeasurement(Measurement measurement) async {
    try {
      isLoading.value = true;
      await _measurementService.editMeasurement(
        measurementId: measurement.id,
        n: measurement.n,
        p: measurement.p,
        k: measurement.k,
        ph: measurement.ph,
        rainfall: measurement.rainfall,
        temperature: measurement.temperature,
        humidity: measurement.humidity,
      );
      fetchMeasurements(measurement.fieldId);
      showCustomSnackbar(
        title: 'Success',
        message: 'Measurement updated successfully',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to update measurement: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMeasurement(Measurement measurement) async {
    try {
      isLoading.value = true;
      await _measurementService.deleteMeasurement(measurement.id);
      fetchMeasurements(measurement.fieldId);
      showCustomSnackbar(
        title: 'Success',
        message: 'Measurement deleted successfully',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to delete measurement: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
