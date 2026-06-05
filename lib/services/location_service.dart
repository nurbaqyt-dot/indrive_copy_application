import 'package:latlong2/latlong.dart';

import '../core/constants.dart';

class LocationService {
  List<Map<String, String>> getCities() => AppConstants.kazakhstanCities;

  List<Map<String, String>> filterCities(String query) {
    if (query.trim().isEmpty) {
      return getCities();
    }

    final normalized = query.toLowerCase();
    return getCities()
        .where((city) => city['name']!.toLowerCase().contains(normalized))
        .toList();
  }

  List<String> filterDestinations(String query) {
    if (query.trim().isEmpty) {
      return AppConstants.destinationSuggestions;
    }

    final normalized = query.toLowerCase();
    return AppConstants.destinationSuggestions
        .where((item) => item.toLowerCase().contains(normalized))
        .toList();
  }

  LatLng cityCenterFor(String city) {
    switch (city) {
      case 'Шымкент':
        return const LatLng(42.3417, 69.5901);
      case 'Алматы':
        return const LatLng(43.2389, 76.8897);
      case 'Нур-Султан':
        return const LatLng(51.1694, 71.4491);
      case 'Актобе':
        return const LatLng(50.2839, 57.1669);
      case 'Қарағанды':
        return const LatLng(49.8060, 73.0850);
      default:
        return AppConstants.defaultCenter;
    }
  }
}
