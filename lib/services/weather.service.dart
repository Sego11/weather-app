import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather.model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final uri = Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric');
    print('apiUrl: $uri');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print(response.statusCode);
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      print('API Error: ${response.body}');
      throw Exception("Failed to load data");
    }
  }

  Future<String> getCurrentCity() async {
    //get user permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //convert the city into a list of placemarks objects

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract the city name from the first placemark

    String? city = placemarks[0].locality;

    return city ?? "";
  }
}