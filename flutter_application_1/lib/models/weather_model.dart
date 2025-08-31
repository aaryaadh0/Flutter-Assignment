// weather_model.dart
class Weather {
  final String city;
  final String description;
  final double temperature;
  final String iconCode;
  final DateTime dateTime;

  Weather({
    required this.city,
    required this.description,
    required this.temperature,
    required this.iconCode,
    required this.dateTime,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      iconCode: json['weather'][0]['icon'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true),
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';
}
