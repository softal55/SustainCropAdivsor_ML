import 'package:crop_recommendation/app/controllers/fields_controller.dart';
import 'package:crop_recommendation/app/models/field.dart';
import 'package:crop_recommendation/app/models/point.dart';
import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:crop_recommendation/app/utils/validator.dart';
import 'package:crop_recommendation/app/views/shared/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapxController extends GetxController {
  final FieldController fieldController = Get.find<FieldController>();
  final MapController controller = MapController();
  final Rx<Marker?> userLocationMarker = Rx<Marker?>(null);
  final RxList<LatLng> polygonPoints = <LatLng>[].obs;
  final RxList<Marker> polygonMarkers = <Marker>[].obs;
  final isDrawing = true.obs;
  final isSatelliteView = true.obs;
  final userLocation = Rx<LatLng?>(null);
  final currentZoom = 8.0.obs;
  final savedFields = <Field>[].obs;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSavedFields();
    });
  }

  Future<void> loadSavedFields() async {
    try {
      await fieldController.fetchFields();
      savedFields.assignAll(fieldController.fields);
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to load fields: ${e.toString()}',
        backgroundColor: AppColors.error,
      );
    }
  }

  void toggleDrawing() {
    isDrawing.toggle();
    if (!isDrawing.value) {
      polygonPoints.clear();
      polygonMarkers.clear();
    }
  }

  void toggleView() {
    isSatelliteView.toggle();
  }

  void addPoint(LatLng point) {
    if (isDrawing.value) {
      polygonPoints.add(point);
      polygonMarkers.add(
        Marker(
          point: point,
          child: Icon(CupertinoIcons.map_pin, color: Colors.green, size: 30),
        ),
      );
    }
  }

  void finishDrawing() {
    if (polygonPoints.length < 3) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Please add at least 3 points to define a field',
        backgroundColor: AppColors.error,
      );
      return;
    }
    showConfirmationDialog();
  }

  void showConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          "Save Field",
          style: TextStyle(color: AppColors.secondary),
        ),
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Field Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: Validator.requiredField('Field Name'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              polygonPoints.clear();
              polygonMarkers.clear();
              nameController.clear();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.error),
            ),
          ),
          TextButton(
            onPressed: saveField,
            child: const Text(
              "Save",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> locateUser() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showCustomSnackbar(
          title: 'Failed',
          message: 'Location services are disabled please enable them',
          backgroundColor: AppColors.warning,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showCustomSnackbar(
            title: 'Failed',
            message: 'Location permission denied.',
            backgroundColor: AppColors.warning,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showCustomSnackbar(
          title: 'Failed',
          message: 'Location permissions are permanently denied.',
          backgroundColor: AppColors.error,
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      userLocation.value = LatLng(position.latitude, position.longitude);
      userLocationMarker.value = Marker(
        point: userLocation.value!,
        child: Icon(Icons.location_pin, color: AppColors.error, size: 30),
      );
      controller.move(userLocation.value!, 17);
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Failed to get location: ${e.toString()}',
        backgroundColor: AppColors.error,
      );
    }
  }

  double calculateArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;

    double area = 0.0;
    for (int i = 0; i < points.length; i++) {
      final j = (i + 1) % points.length;
      area += points[i].latitude * points[j].longitude;
      area -= points[j].latitude * points[i].longitude;
    }

    return (area.abs() / 2) * 111319.9 * 111319.9;
  }

  Future<void> saveField() async {
    if (formKey.currentState!.validate()) {
      Get.back();

      double area = calculateArea(polygonPoints);

      // Convert LatLng to Point model
      List<Point> pointModels =
          polygonPoints
              .map(
                (p) =>
                    Point(latitude: p.latitude, longitude: p.longitude, id: 0),
              )
              .toList();

      final newField = Field(
        id: 0,
        name: nameController.text,
        points: pointModels,
        area: area,
      );

      await fieldController.addField(newField);

      Get.offAllNamed('/fields');

      polygonPoints.clear();
      nameController.clear();
    }
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
