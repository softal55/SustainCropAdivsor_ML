import 'package:crop_recommendation/app/controllers/mapx_controller.dart';
import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:crop_recommendation/app/views/field/widgets/search_bar.dart'
    as search;

class AddFieldView extends StatelessWidget {
  AddFieldView({super.key});

  final MapxController mapxController = Get.find<MapxController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Field',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.close,
                        color: AppColors.secondary,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(
                  () => Stack(
                    children: [
                      FlutterMap(
                        mapController: mapxController.controller,
                        options: MapOptions(
                          initialCenter: const LatLng(36.752887, 3.042048),
                          initialZoom: 4,
                          onTap:
                              (tapPosition, point) =>
                                  mapxController.addPoint(point),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                mapxController.isSatelliteView.value
                                    ? "https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}"
                                    : "https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}",
                            subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                          ),
                          if (mapxController.savedFields.isNotEmpty)
                            PolygonLayer(
                              polygons:
                                  mapxController.savedFields
                                      .map(
                                        (field) => Polygon(
                                          points:
                                              field.points
                                                  .map(
                                                    (p) => LatLng(
                                                      p.latitude,
                                                      p.longitude,
                                                    ),
                                                  )
                                                  .toList(),
                                          color: AppColors.background
                                              .withValues(alpha: 0.5),
                                          borderColor: Colors.yellow,
                                          borderStrokeWidth: 3,
                                        ),
                                      )
                                      .toList(),
                            ),
                          if (mapxController.polygonPoints.isNotEmpty)
                            PolygonLayer(
                              polygons: [
                                Polygon(
                                  points: mapxController.polygonPoints,
                                  color: AppColors.background.withValues(
                                    alpha: 0.5,
                                  ),
                                  borderColor: AppColors.borders,
                                  borderStrokeWidth: 3,
                                ),
                              ],
                            ),
                          if (mapxController.polygonMarkers.isNotEmpty)
                            MarkerLayer(markers: mapxController.polygonMarkers),
                          if (mapxController.userLocationMarker.value != null)
                            MarkerLayer(
                              markers: [
                                mapxController.userLocationMarker.value!,
                              ],
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          right: 20,
                          left: 20,
                        ),
                        child: search.SearchBar(
                          onLocationSelected: (LatLng location) {
                            mapxController.controller.move(
                              location,
                              15.0,
                            ); // Move to selected location
                          },
                        ),
                      ),
                      Positioned(
                        right: 20,
                        bottom: 220,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.background.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: mapxController.toggleDrawing,
                            icon: Icon(
                              mapxController.isDrawing.value
                                  ? Icons.close
                                  : Icons.edit,
                            ),
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        bottom: 160,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.background.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: mapxController.toggleView,
                            icon: const Icon(Icons.layers_outlined),
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        bottom: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.background.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: mapxController.locateUser,
                            icon: const Icon(Icons.my_location_rounded),
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          onPressed: mapxController.finishDrawing,
          child: const Icon(Icons.done_rounded),
        ),
      ),
    );
  }
}
