import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/weather_models.dart';

import 'get_weather.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WeatherController weather = WeatherController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: Scaffold(
        backgroundColor: Color(0xFFE9EDFA),
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Color(0xFFE9EDFA),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 500,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage("assets/images/outdoor.png")),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 20,
                    child: FutureBuilder<Position>(
                      future: weather.getLatLang(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Loading
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CardLoading(
                                      height: 30,
                                      width: 30,
                                      borderRadius: BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    CardLoading(
                                      height: 30,
                                      width: 140,
                                      borderRadius: BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CardLoading(
                                      height: 30,
                                      width: 120,
                                      borderRadius: BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    CardLoading(
                                      height: 20,
                                      width: 250,
                                      borderRadius: BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                CardLoading(
                                  height: 20,
                                  width: 80,
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Get City Name
                          Position position = snapshot.data;
                          return FutureBuilder<WeatherModels?>(
                            future: weather.getDetailWeather(
                                lat: position.latitude.toString(),
                                long: position.longitude.toString()),
                            builder: (BuildContext context, snapshot) {
                              WeatherModels? weatherModels = snapshot.data;
                              if (weatherModels?.name == null) {
                                return Center(
                                  child: Text(""),
                                );
                              } else {
                                return Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.location_on_outlined),
                                          Text(
                                            "${weatherModels?.name}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF4E5E9B)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Image(
                                                  image: NetworkImage(
                                                      "https://openweathermap.org/img/wn/${weatherModels?.weather?[0].icon}.png"),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "${weatherModels?.main?.temp}°C",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Feels like ${weatherModels?.main?.temp}°C. ${weatherModels?.weather?[0].main}." +
                                                " ${weatherModels?.weather?[0].description!.toTitleCase()}.",
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                          "Humidity: ${weatherModels?.main?.humidity}%"),
                                    ],
                                  ),
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                  ),
                  Dialog(),
                  Positioned(bottom: 0, child: SearchCity()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dialog extends StatefulWidget {
  const Dialog({
    Key? key,
  }) : super(key: key);

  @override
  State<Dialog> createState() => _DialogState();
}

class _DialogState extends State<Dialog> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 20,
      child: IconButton(
        onPressed: () => showAlertDialog(context),
        icon: Icon(Icons.info),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("About Application"),
    content: Container(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Version"),
              Text("1.0"),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Icon Credit"),
              Text("flaticon.com"),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Bg Credit"),
              Text("iconscout.com"),
            ],
          ),
        ],
      ),
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class SearchCity extends StatefulWidget {
  @override
  State<SearchCity> createState() => _SearchCityState();
}

WeatherController weather = WeatherController();

class _SearchCityState extends State<SearchCity> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 250,
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFB0C1F1),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 5),
                      color: Colors.grey,
                      spreadRadius: -8,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: TextField(
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) {
                    weather.getData();
                    setState(() {});
                  },
                  controller: weather.city,
                  style: TextStyle(
                    color: Color(0xFF4E5E9B),
                  ),
                  cursorColor: Color(0xFF4E5E9B),
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "Cari Kota",
                    hintStyle: TextStyle(
                      color: Color(0xFF4E5E9B),
                    ),
                    border: InputBorder.none,
                    focusColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  weather.getData();
                  setState(() {});
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFB0C1F1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(2, 5),
                        color: Colors.grey,
                        spreadRadius: -8,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          FutureBuilder<WeatherModels?>(
            future: weather.getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              WeatherModels? weatherModels = snapshot.data;
              String data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFB0C1F1),
                  ),
                  child: Center(
                    child: Text(
                      "Loading",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else if (weather.city.text == "") {
                return Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFB0C1F1),
                  ),
                  child: Center(
                    child: Text(
                      "Ketik untuk mencari kota!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else if (weatherModels?.name == null) {
                return Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFB0C1F1),
                  ),
                  child: Center(
                    child: Text(
                      "Kota tidak ditemukan!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else {
                return Container(
                  width: 320,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFB0C1F1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cuaca di ${weatherModels?.name}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image(
                                image: NetworkImage(
                                    "https://openweathermap.org/img/wn/${weatherModels?.weather?[0].icon}.png"),
                              ),
                              Text(
                                "${weatherModels?.main?.temp}°C",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Feels like ${weatherModels?.main?.temp}°C. ${weatherModels?.weather?[0].main}." +
                                " ${weatherModels?.weather?[0].description!.toTitleCase()}.",
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text("Humidity: ${weatherModels?.main?.humidity}%"),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
