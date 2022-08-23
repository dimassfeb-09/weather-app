import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geoloc;
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:weatherapp/weather_models.dart';

class WeatherController {
  TextEditingController city = TextEditingController();

  // Input data
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

  // Current Location User
  Future<WeatherModels?> getDetailWeather(
      {required String lat, required String long}) async {
    Uri url = Uri.parse(
        "https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$lat&longitude=$long&localityLanguage=en");
    final response = await http.get(url);

    Map<String, dynamic> data =
        (jsonDecode(response.body) as Map<String, dynamic>);

    final responseWeather = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${data['city']}&appid=0ab0be7030506c822d48cf2423c4f7a4&units=metric"));
    var fetchDataCurrentCity = jsonDecode(responseWeather.body);

    return WeatherModels.fromJson(fetchDataCurrentCity);
  }

  // Get Latitude and Longitude
  Future<geoloc.Position> getLatLang() async {
    bool serviceEnabled;
    geoloc.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geoloc.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await geoloc.Geolocator.checkPermission();
    if (permission == geoloc.LocationPermission.denied) {
      permission = await geoloc.Geolocator.requestPermission();
      if (permission == geoloc.LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geoloc.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await geoloc.Geolocator.getCurrentPosition();
  }
}
