import 'package:flutter/material.dart';
import 'package:weather_app/app/data/api/network.dart';
import 'package:weather_app/app/data/models/daily_weather_model.dart';
import 'package:weather_app/app/screens/widgets/daily_forecast_list.dart';

class DailyForecastScreen extends StatefulWidget {
  final double lat;
  final double lon;
  const DailyForecastScreen({super.key, required this.lat, required this.lon});

  @override
  State<DailyForecastScreen> createState() => _DailyForecastScreenState();
}

class _DailyForecastScreenState extends State<DailyForecastScreen> {
  List<ListElement> dailyWeather = [];

  @override
  void initState() {
    super.initState();
    getDailyWeather();
  }

  Future<void> getDailyWeather() async {
    var fetchData = await Network.getDailyWeather(widget.lat, widget.lon);
    setState(() {
      dailyWeather = fetchData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Text(
                    "Weather forecast ${dailyWeather.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
            dailyWeather.isNotEmpty
                ? Positioned(
                    top: 120,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 80,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: dailyWeather.length,
                        itemBuilder: (context, index) {
                          return DailyForecastList(
                              listElement: dailyWeather[index]);
                        },
                      ),
                    ))
                : const Positioned(
                    top: 400,
                    left: 180,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
