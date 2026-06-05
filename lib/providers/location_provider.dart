import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  LocationProvider() {
    _load();
  }

  final LocationService _locationService = LocationService();

  String _selectedCity = AppConstants.defaultCity;
  List<Map<String, String>> _filteredCities = AppConstants.kazakhstanCities;
  bool _isReady = false;

  String get selectedCity => _selectedCity;
  List<Map<String, String>> get filteredCities => _filteredCities;
  bool get isReady => _isReady;
  LatLng get selectedCityCenter =>
      _locationService.cityCenterFor(_selectedCity);

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCity =
        prefs.getString('selected_city') ?? AppConstants.defaultCity;
    _filteredCities = _locationService.getCities();
    _isReady = true;
    notifyListeners();
  }

  Future<void> setSelectedCity(String city) async {
    _selectedCity = city;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_city', city);
    notifyListeners();
  }

  void filterCities(String query) {
    _filteredCities = _locationService.filterCities(query);
    notifyListeners();
  }

  List<String> filterDestinations(String query) {
    return _locationService.filterDestinations(query);
  }
}
