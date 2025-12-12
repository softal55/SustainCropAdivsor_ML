import 'package:crop_recommendation/app/models/field.dart';
import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FieldMapTab extends StatelessWidget {
  final Field field;

  const FieldMapTab({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    final points =
        field.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
    final center = _calculateCenter(points);
    final zoom = _calculateZoomFromArea(field.area);

    return FlutterMap(
      options: MapOptions(initialCenter: center, initialZoom: zoom),
      children: [
        TileLayer(
          urlTemplate: 'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
        ),
        PolygonLayer(
          polygons: [
            Polygon(
              points: points,
              color: AppColors.background.withValues(alpha: 0.4),
              borderColor: AppColors.borders,
              borderStrokeWidth: 1.5,
            ),
          ],
        ),
      ],
    );
  }

  LatLng _calculateCenter(List<LatLng> points) {
    if (points.isEmpty) return LatLng(0, 0);
    final bounds = LatLngBounds.fromPoints(points);
    return bounds.center;
  }

  double _calculateZoomFromArea(double areaInSquareMeters) {
    if (areaInSquareMeters > 1000000) return 15;
    if (areaInSquareMeters > 100000) return 16;
    if (areaInSquareMeters > 50000) return 17;
    if (areaInSquareMeters > 10000) return 18;
    if (areaInSquareMeters > 5000) return 19;
    if (areaInSquareMeters > 1000) return 20;
    return 18.0;
  }
}
