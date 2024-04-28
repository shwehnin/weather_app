import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather_app/app/data/api/network.dart';
import 'package:weather_app/app/data/models/weather_model.dart';
import 'package:weather_app/app/screens/search_city_screen.dart';
import 'package:weather_app/app/screens/daily_forecast_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Location location = Location();

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  WeatherModel? weather;

  double? lat;
  double? lon;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    lat = _locationData?.latitude;
    lon = _locationData?.longitude;

    final fetchWeather = await Network.getWeather();
    setState(() {
      weather = fetchWeather;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isNight = true;
    var hour = DateTime.now().hour;
    if (hour >= 6 && hour <= 18) {
      isNight = false;
    }
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                          Color.fromARGB(255, 104, 123, 246), BlendMode.darken),
                      child: Image.asset(
                        isNight
                            ? "assets/images/night.jpeg"
                            : "assets/images/bg_img.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weather!.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          DateFormat("EEEE dd, MMMM").format(
                            DateTime.now(),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          DateFormat().add_jm().format(
                                DateTime.now(),
                              ),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DailyForecastScreen(
                                  lat: lat!,
                                  lon: lon!,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "weather forecast",
                            style: TextStyle(color: Colors.indigo),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${weather!.main.temp} °C",
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              weather!.weather[0].main,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.network(
                                  "https://openweathermap.org/img/wn/${weather!.weather[0].icon}@2x.png"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 95,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SearchCityScreen(),
                        ),
                      ),
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
