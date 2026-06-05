import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../models/route_model.dart';

export 'colors.dart';

class AppConstants {
  static const String appName = 'inDrive Clone';
  static const String defaultCity = 'Тараз';
  static const String legalUrl = 'https://indrive.com/legal';
  static const String userAgentPackageName = 'com.example.indrive_clone';
  static const LatLng defaultCenter = LatLng(42.9, 71.4);
  static const double defaultZoom = 14.0;
  static const String currentAddress = 'улица Пушкина, 154';

  static const List<Map<String, dynamic>> homeServices = [
    {
      'icon': Icons.directions_car,
      'title': 'Поездки по городу',
      'subtitle': 'Возите пассажиров по городу',
      'route': '/city-ride',
    },
    {
      'icon': Icons.local_shipping_outlined,
      'title': 'Курьер',
      'subtitle': 'Доставляйте посылки до 20 кг по городу',
      'route': '/courier',
    },
    {
      'icon': Icons.map_outlined,
      'title': 'Водитель по межгороду',
      'subtitle': 'Перевозите пассажиров между городами',
      'route': '/intercity',
    },
    {
      'icon': Icons.fire_truck_outlined,
      'title': 'Водитель грузового авто',
      'subtitle': 'Доставьте грузы весом более 20 кг',
      'route': '/freight',
    },
  ];

  static final List<AppRouteModel> popularRoutes = [
    AppRouteModel(title: 'Тараз-Шымкент (Чимкент)', count: 134),
    AppRouteModel(title: 'Тараз-Шу', count: 157),
    AppRouteModel(title: 'Тараз-Қапланбек', count: 132),
    AppRouteModel(title: 'Тараз-Қордай', count: 117),
    AppRouteModel(title: 'Тараз-Туркестан', count: 103),
  ];

  static const List<Map<String, String>> kazakhstanCities = [
    {'name': 'Тараз', 'region': 'Жамбылская область'},
    {'name': 'Бесколь', 'region': 'Жамбылская область'},
    {'name': 'Капчагай', 'region': 'Алматинская область'},
    {'name': 'Коктал', 'region': 'Жамбылская область'},
    {'name': 'Ульгули', 'region': 'Жамбылская область'},
    {'name': 'Сарыкемер', 'region': 'Жамбылская область'},
    {'name': 'Гродеково', 'region': 'Жамбылская область'},
    {'name': 'Кылыздыкан', 'region': 'Жамбылская область'},
    {'name': 'Байзак', 'region': 'Жамбылская область'},
    {'name': 'Кызылкайнар', 'region': 'Жамбылская область'},
    {'name': 'Сенкибай', 'region': 'Жамбылская область'},
    {'name': 'Шымкент', 'region': 'Туркестанская область'},
    {'name': 'Алматы', 'region': 'Алматинская область'},
    {'name': 'Астана', 'region': 'Акмолинская область'},
    {'name': 'Нур-Султан', 'region': 'Акмолинская область'},
    {'name': 'Актобе', 'region': 'Актюбинская область'},
    {'name': 'Қарағанды', 'region': 'Карагандинская область'},
  ];

  static const List<Map<String, dynamic>> rideTariffs = [
    {
      'id': 'economy',
      'label': 'Эконом',
      'subtitle': 'до 4 мест',
      'icon': Icons.directions_car_outlined,
    },
    {
      'id': 'comfort',
      'label': 'Комфорт',
      'subtitle': 'до 4 мест',
      'icon': Icons.directions_car_filled_outlined,
    },
    {
      'id': 'suv',
      'label': 'Кроссовер',
      'subtitle': 'до 6 мест',
      'icon': Icons.airport_shuttle_outlined,
    },
    {
      'id': 'minivan',
      'label': 'Минивэн',
      'subtitle': 'до 7 мест',
      'icon': Icons.directions_bus_outlined,
    },
  ];

  static const List<String> rideWishes = [
    'Тихо',
    'Не курить',
    'С багажом',
    'Детское кресло',
    'С детьми',
    'Животные',
  ];

  static const List<String> destinationSuggestions = [
    'Поликлиника №1',
    'Поликлиника №2',
    'Автовокзал Тараз',
    'Монтажное',
    'ТРЦ Mart',
    'Железнодорожный вокзал',
    'Микрорайон Талас',
  ];

  static const List<String> freightBodyTypes = [
    'Тент',
    'Изотерм',
    'Фургон',
    'Рефрижератор',
    'Бортовой',
  ];

  static const List<String> helpServices = [
    'Город',
    'Межгород',
    'Курьеры',
    'Грузовые',
    'Продукты',
  ];

  static const List<String> helpMore = ['Вопросы по приложению', 'О inDrive'];
}
