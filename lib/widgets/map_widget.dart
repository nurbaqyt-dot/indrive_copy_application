import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../core/constants.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({
    super.key,
    required this.markers,
    this.center = AppConstants.defaultCenter,
    this.zoom = AppConstants.defaultZoom,
  });

  final LatLng center;
  final double zoom;
  final List<Marker> markers;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(initialCenter: center, initialZoom: zoom),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: AppConstants.userAgentPackageName,
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
