import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants.dart';
import '../../../../widgets/map_widget.dart';

class MapPlaceholder extends StatelessWidget {
  const MapPlaceholder({super.key, this.center});

  final LatLng? center;

  @override
  Widget build(BuildContext context) {
    final mapCenter = center ?? AppConstants.defaultCenter;

    return Stack(
      fit: StackFit.expand,
      children: [
        MapWidget(
          center: mapCenter,
          markers: [
            Marker(
              width: 64,
              height: 64,
              point: mapCenter,
              child: const Icon(
                Icons.location_pin,
                color: AppColors.primary,
                size: 48,
              ),
            ),
            Marker(
              width: 36,
              height: 36,
              point: LatLng(
                mapCenter.latitude + 0.004,
                mapCenter.longitude + 0.006,
              ),
              child: _DriverPin(),
            ),
            Marker(
              width: 36,
              height: 36,
              point: LatLng(
                mapCenter.latitude - 0.003,
                mapCenter.longitude - 0.005,
              ),
              child: _DriverPin(),
            ),
            Marker(
              width: 36,
              height: 36,
              point: LatLng(
                mapCenter.latitude + 0.002,
                mapCenter.longitude - 0.007,
              ),
              child: _DriverPin(),
            ),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 320,
          child: Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            elevation: 3,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.layers_outlined,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DriverPin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 6,
          ),
        ],
      ),
      child: const Icon(
        Icons.directions_car_filled,
        size: 18,
        color: AppColors.textPrimary,
      ),
    );
  }
}
