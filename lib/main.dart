import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/weather_models.dart';

import 'get_weather.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WeatherController weather = WeatherController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
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
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage("assets/images/outdoor.png")),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 20,
                    child: FutureBuilder(
                      future: weather.getLocation(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          return FutureBuilder<WeatherModels?>(
                            future: weather.getLocationWeather(
                                cityName: snapshot.data),
                            builder: (BuildContext context, snapshot) {
                              WeatherModels? weatherModels = snapshot.data;
                              if (weatherModels?.name == null) {
                                return Center(
                                  child: Text(""),
                                );
                              } else {
                                return Container(
                                  child: Column(
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
                  Positioned(
                    bottom: 10,
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 260,
                          padding: EdgeInsets.only(left: 13),
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
                        SizedBox(width: 10),
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
                  ),
                ],
              ),
              FutureBuilder<WeatherModels?>(
                future: weather.getData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  WeatherModels? weatherModels = snapshot.data;
                  String data;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      padding: EdgeInsets.all(10),
                      width: 500,
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
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      padding: EdgeInsets.all(10),
                      width: 500,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFB0C1F1),
                      ),
                      child: Center(
                        child: Text(
                          "Input kota!",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  } else if (weatherModels?.name == null) {
                    return Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      padding: EdgeInsets.all(10),
                      width: 500,
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
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      padding: EdgeInsets.all(10),
                      width: 500,
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
        ),
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
