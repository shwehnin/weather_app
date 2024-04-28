import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/app/data/models/daily_weather_model.dart';

class DailyForecastList extends StatelessWidget {
  final ListElement listElement;
  const DailyForecastList({super.key, required this.listElement});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.lightBlueAccent,
                  title: Text(
                    DateFormat("EEEE dd, MMMM").format(
                      DateTime.fromMillisecondsSinceEpoch(
                        listElement.dt * 1000,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        "https://openweathermap.org/img/wn/${listElement!.weather[0].icon}@2x.png",
                      ),
                      Text(
                        listElement.weather[0].main,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Max Temperature : ${listElement.main.tempMax} °C",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Min Temperature : ${listElement.main.tempMin} °C",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Day Temperature : ${listElement.main.temp} °C",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Wind Speed : ${listElement.wind.speed} meter/sec",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        child: Card(
          color: Colors.lightBlue,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      "https://openweathermap.org/img/wn/${listElement!.weather[0].icon}@2x.png",
                    ),
                    Text(
                      listElement.weather[0].main,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Text(
                  DateFormat("EEEE dd, MMMM").format(
                    DateTime.fromMillisecondsSinceEpoch(listElement.dt * 1000),
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
