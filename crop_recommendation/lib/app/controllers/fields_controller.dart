import 'package:crop_recommendation/app/models/field.dart';
import 'package:crop_recommendation/app/models/prediction.dart';
import 'package:crop_recommendation/app/services/field_service.dart';
import 'package:crop_recommendation/app/views/shared/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldController extends GetxController {
  final FieldService _fieldService = FieldService();

  var fields = <Field>[].obs;
  var predictions = <Prediction>[].obs;
  var isLoading = false.obs;
  var selectedFieldId = 0.obs;

  // For search functionality
  var searchQuery = ''.obs;

  // Computed property for filtered fields
  List<Field> get filteredFields => fields
      .where((field) =>
          field.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
      .toList();

  @override
  void onInit() {
    super.onInit();
    fetchFields();
  }

  Future<void> fetchFields() async {
    isLoading.value = true;
    try {
      final data = await _fieldService.getUserFields();
      fields.value = data.map((e) => Field.fromJson(e)).toList();
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to load fields!',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addField(Field field) async {
    try {
      isLoading.value = true;
      await _fieldService.addField(
        name: field.name,
        area: field.area,
        points: field.points
            .map((p) => {'latitude': p.latitude, 'longitude': p.longitude})
            .toList(),
      );
      showCustomSnackbar(
        title: 'Success',
        message: 'Field added successfully',
        backgroundColor: Colors.green,
      );
      fetchFields();
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to add field! $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editField(Field field) async {
    try {
      isLoading.value = true;
      await _fieldService.editField(
        fieldId: field.id,
        name: field.name,
        area: field.area,
      );
      fetchFields();
      showCustomSnackbar(
        title: 'Success',
        message: 'Field updated successfully',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to update field!',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteField(int fieldId) async {
    try {
      isLoading.value = true;
      await _fieldService.deleteField(fieldId);
      await fetchFields();
      showCustomSnackbar(
        title: 'Success',
        message: 'Field deleted successfully',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to delete field!',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update the search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}
