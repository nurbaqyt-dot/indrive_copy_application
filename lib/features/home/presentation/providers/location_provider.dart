import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants.dart';
import '../../../../services/location_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

class LocationState {
  const LocationState({
    this.selectedCity = AppConstants.defaultCity,
    this.isReady = false,
  });

  final String selectedCity;
  final bool isReady;
}

class LocationNotifier extends AsyncNotifier<LocationState> {
  @override
  Future<LocationState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('selected_city') ?? AppConstants.defaultCity;
    return LocationState(selectedCity: city, isReady: true);
  }

  Future<void> setSelectedCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_city', city);
    state = AsyncData(LocationState(selectedCity: city, isReady: true));
  }

  LatLng cityCenter() {
    final city = state.valueOrNull?.selectedCity ?? AppConstants.defaultCity;
    return ref.read(locationServiceProvider).cityCenterFor(city);
  }

  List<String> filterDestinations(String query) {
    return ref.read(locationServiceProvider).filterDestinations(query);
  }
}

final locationProvider = AsyncNotifierProvider<LocationNotifier, LocationState>(
  LocationNotifier.new,
);

final selectedCityProvider = Provider<String>((ref) {
  return ref.watch(locationProvider).valueOrNull?.selectedCity ??
      AppConstants.defaultCity;
});
