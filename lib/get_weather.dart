import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:weatherapp/weather_models.dart';

class WeatherController {
  TextEditingController city = TextEditingController();

  Future<WeatherModels> getData() async {
    final URL =
        "https://api.openweathermap.org/data/2.5/weather?q=${city.text}&appid=0ab0be7030506c822d48cf2423c4f7a4&units=metric";
    var response = await http.get(Uri.parse(URL));

    Map<String, dynamic> fetchData =
        (jsonDecode(response.body) as Map<String, dynamic>);

    if (fetchData['cod'] == "400") {
      return WeatherModels.fromJson(fetchData);
    } else {
      return WeatherModels.fromJson(fetchData);
    }
  }

  Future getLocation() async {
    String? cityName;

    Location location = new Location();
    late PermissionStatus _permissionGranted;
    late LocationData _locationData;
    late bool _serviceEnabled;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {}
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {}
    }

    _locationData = await location.getLocation();

    String URLCITY =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${_locationData.latitude},${_locationData.longitude}&key=AIzaSyBy-S8FynvP97nnSstptIP2T2uZJr-9UBA";
    final responseCity = await http.get(Uri.parse(URLCITY));

    List fetchDataCity =
        (jsonDecode(responseCity.body) as Map<String, dynamic>)['results'];

    for (var i = 0; i < fetchDataCity[1]['address_components'].length; i++) {
      if (fetchDataCity[1]['address_components'][i]['types'][0] ==
          "administrative_area_level_2") {
        cityName = fetchDataCity[1]['address_components'][i]['long_name'];
      }
    }

    return cityName;
  }

  Future<WeatherModels?> getLocationWeather({required String cityName}) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=0ab0be7030506c822d48cf2423c4f7a4&units=metric"));
    var fetchDataCurrentCity = jsonDecode(response.body);

    return WeatherModels.fromJson(fetchDataCurrentCity);
  }
}
