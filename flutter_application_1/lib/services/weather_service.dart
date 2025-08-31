import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/weather_model.dart';

class WeatherService {
  static const String _apiKey = '49df99a17e830f4b17d43bc45bfdbdb5';

  static Future<Weather> fetchWeather(String city, {bool isCelsius = true}) async {
    final units = isCelsius ? 'metric' : 'imperial';
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&units=$units&appid=$_apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) throw Exception('Failed to fetch weather');
    final json = jsonDecode(response.body);
    return Weather.fromJson(json);
  }

  static Future<List<Weather>> fetch7DayForecast(String city, {bool isCelsius = true}) async {
    try {
      final units = isCelsius ? 'metric' : 'imperial';
      final url =
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=$units&appid=$_apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) throw Exception('Failed to fetch daily forecast');

      final json = jsonDecode(response.body);
      final List<dynamic> list = json['list'];

      Map<String, Weather> dailyMap = {};
      for (var item in list) {
        final dt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000, isUtc: true);
        final dayKey = '${dt.year}-${dt.month}-${dt.day}';

        if (dt.hour == 12 && !dailyMap.containsKey(dayKey)) {
          dailyMap[dayKey] = Weather(
            city: city,
            description: item['weather'][0]['description'],
            temperature: (item['main']['temp'] as num).toDouble(),
            iconCode: item['weather'][0]['icon'],
            dateTime: dt,
          );
        }
      }

      return dailyMap.values.take(7).toList();
    } catch (e) {
      throw Exception('Failed to fetch daily forecast');
    }
  }

  static Future<List<Weather>> fetchHourlyForecast(String city, {bool isCelsius = true}) async {
    try {
      final units = isCelsius ? 'metric' : 'imperial';
      final url =
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=$units&appid=$_apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) throw Exception('Failed to fetch hourly forecast');

      final json = jsonDecode(response.body);
      final List<dynamic> list = json['list'];

      return list.take(8).map((item) {
        final dt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000, isUtc: true);
        return Weather(
          city: city,
          description: item['weather'][0]['description'],
          temperature: (item['main']['temp'] as num).toDouble(),
          iconCode: item['weather'][0]['icon'],
          dateTime: dt,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch hourly forecast');
    }
  }
}