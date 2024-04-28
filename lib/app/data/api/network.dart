import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/app/constants/constants.dart';
import 'package:weather_app/app/data/models/weather_model.dart';
import 'package:weather_app/app/data/models/daily_weather_model.dart';

class Network {
  static getWeather() async {
    var url = Uri.parse(
        "${Constants.baseUrl}weather?lat=16.83362192842896&lon=96.12657070274646&appid=${Constants.appId}&units=metric");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);
      WeatherModel weather = WeatherModel.fromJson(decodedData);
      return weather;
    } else {
      throw Exception('Failed to load weather');
    }
  }

  static getCityWeather(String cityName) async {
    var url = Uri.parse(
        "${Constants.baseUrl}weather?q=$cityName&appid=${Constants.appId}&units=metric");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);
      WeatherModel weather = WeatherModel.fromJson(decodedData);
      return weather;
    } else {
      throw Exception('Failed to load weather');
    }
  }

  static Future<List<ListElement>> getDailyWeather(
      double lat, double lon) async {
    var url = Uri.parse(
        "${Constants.baseUrl}forecast?lat=$lat&lon=$lon&appid=${Constants.appId}&units=metric");
    print("Daily url ${url}");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);
      print("Daily data $decodedData");

      if (decodedData['list'] != null && decodedData['list'] is List) {
        List<ListElement> dailyWeather = (decodedData['list'] as List)
            .map((e) => ListElement.fromJson(e))
            .toList();
        return dailyWeather;
      } else {
        print("Invalid data format: 'list' is null or not a List");
        return [];
      }
    } else {
      print("Error: ${response.statusCode}");
      return [];
    }
  }
}
