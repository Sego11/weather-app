import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.model.dart';
import 'package:weather_app/services/weather.service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  //api key
  final _weatherService = WeatherService('a17cca0a0ad95124d029bd93cdfac3e3');
  Weather? _weather;

  //fetch weather

  _fetchWeather() async {
    //get current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for the city

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    //fetch weather
    _fetchWeather();
  }

  //weather animation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? 'loading city...'),
            //temperature
            Text('${_weather?.temperature.round().toString()} ℃'),
          ],
        ),
      ),
    );
  }
}
