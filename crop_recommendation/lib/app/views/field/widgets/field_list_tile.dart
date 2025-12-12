import 'package:crop_recommendation/app/controllers/fields_controller.dart';
import 'package:crop_recommendation/app/models/field.dart';
import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:crop_recommendation/app/utils/date_formater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class FieldListTile extends StatelessWidget {
  final FieldController controller = Get.find<FieldController>();
  final Field field;
  FieldListTile({super.key, required this.field});

  LatLng _calculateCenter(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(0, 0);
    final bounds = LatLngBounds.fromPoints(points);
    return bounds.center;
  }

  double _calculateZoomFromArea(double areaInSquareMeters) {
    if (areaInSquareMeters > 1000000) return 12.0; // > 1 km²
    if (areaInSquareMeters > 100000) return 13.0; // > 10 hectares
    if (areaInSquareMeters > 50000) return 14.0; // > 5 hectares
    if (areaInSquareMeters > 10000) return 15.0; // > 1 hectare
    if (areaInSquareMeters > 5000) return 16.0; // > 0.5 hectare
    if (areaInSquareMeters > 1000) return 17.0; // > 0.1 hectare
    return 18.0; // Smaller areas
  }

  @override
  Widget build(BuildContext context) {
    final points =
        field.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
    final center = _calculateCenter(points);
    final zoom = _calculateZoomFromArea(field.area);

    debugPrint('Field: ${field.name}, Center: $center, Zoom: $zoom');

    return ListTile(
      onTap: () {
        // Navigate to Field Details Screen
        Get.toNamed('/field_details', arguments: field);
      },
      leading: SizedBox(
        width: 64,
        height: 64,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FlutterMap(
            key: ValueKey(field.id), // Ensure a unique key for each map
            options: MapOptions(
              initialCenter: center,
              initialZoom: zoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}',
                subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                maxNativeZoom: 19,
                retinaMode: MediaQuery.of(context).devicePixelRatio > 1.0,
              ),
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: points,
                    color: AppColors.background.withValues(alpha: 0.4),
                    borderColor: AppColors.borders.withValues(alpha: 0.8),
                    borderStrokeWidth: 1.5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      title: Text(
        field.name,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        formatDate(field.creationDate!),
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
      trailing: PopupMenuButton<String>(
        color: AppColors.background,
        icon: const Icon(Icons.more_vert, size: 20),
        onSelected: (value) {
          if (value == 'delete') {
            controller.deleteField(field.id);
          }
        },
        borderRadius: BorderRadius.circular(10),
        itemBuilder:
            (BuildContext context) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: AppColors.error, size: 20),
                    const SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
      ),
    );
  }
}
