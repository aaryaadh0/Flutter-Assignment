import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/weather_service.dart';
import 'package:flutter_application_1/models/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String city = 'Kathmandu';
  bool isCelsius = true;

  late Future<Weather> currentWeather;
  late Future<List<Weather>> dailyForecast;
  late Future<List<Weather>> hourlyForecast;

  final pastelYellow = const Color(0xFFFFF6DC);
  final pastelBlue = const Color(0xFFE0F2FF);
  final lavender = const Color(0xFFEAE6FF);

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }


void _logout() async{
  await FirebaseAuth.instance.signOut();
  if(!mounted)return;
  Navigator.popAndPushNamed(context, '/login');
}


  void _loadWeather() {
    setState(() {
      currentWeather = WeatherService.fetchWeather(city, isCelsius: isCelsius);
      dailyForecast = WeatherService.fetch7DayForecast(city, isCelsius: isCelsius);
      hourlyForecast = WeatherService.fetchHourlyForecast(city, isCelsius: isCelsius);
    });
  }

  void _searchCity() {
    final input = _searchController.text.trim();
    if (input.isNotEmpty) {
      setState(() {
        city = input;
        _loadWeather();
      });
    }
  }

  void _toggleUnit() {
    setState(() {
      isCelsius = !isCelsius;
      _loadWeather();
    });
  }

  Color _backgroundColor(String condition) {
    final conditionLower = condition.toLowerCase();
    if (conditionLower.contains('rain')) {
      return pastelBlue;
    } else if (conditionLower.contains('cloud')) {
      return lavender;
    } else {
      return pastelYellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roundedFont = const TextStyle(fontFamily: 'Poppins');

    return FutureBuilder<Weather>(
      future: currentWeather,
      builder: (context, snapshot) {
        Color bgColor = pastelYellow;

        if (snapshot.hasData) {
          bgColor = _backgroundColor(snapshot.data!.description);
        }

        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Search bar
                 // Search bar + Logout in one row
Row(
  children: [
    Expanded(
      child: TextField(
        controller: _searchController,
        onSubmitted: (_) => _searchCity(),
        decoration: InputDecoration(
          hintText: 'Search city...',
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ),
    IconButton(
      icon: const Icon(Icons.search, color: Colors.deepPurple),
      onPressed: _searchCity,
    ),
    IconButton(
      icon: const Icon(Icons.logout, color: Colors.deepPurple),
      tooltip: 'Logout',
      onPressed: _logout,
    ),
  ],
),


                  const SizedBox(height: 10),

                  // Unit toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: _toggleUnit,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Text(
                            isCelsius ? '℃' : '℉',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.deepPurple[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Current weather
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Expanded(child: Center(child: CircularProgressIndicator()))
                      : snapshot.hasError
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  'City not found. Please try again.',
                                  style: roundedFont.copyWith(fontSize: 18, color: Colors.red),
                                ),
                              ),
                            )
                          : Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      snapshot.data!.city,
                                      style: roundedFont.copyWith(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple[800],
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      DateFormat('EEEE, MMM d, hh:mm a').format(DateTime.now()),
                                      style: roundedFont.copyWith(
                                        fontSize: 16,
                                        color: Colors.deepPurple[300],
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    Image.network(
                                      snapshot.data!.iconUrl,
                                      width: 100,
                                      height: 100,
                                    ),

                                    const SizedBox(height: 10),

                                    Text(
                                      '${snapshot.data!.temperature.toStringAsFixed(0)}°${isCelsius ? 'C' : 'F'}',
                                      style: roundedFont.copyWith(
                                        fontSize: 64,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple[800],
                                      ),
                                    ),

                                    Text(
                                      snapshot.data!.description.capitalize(),
                                      style: roundedFont.copyWith(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.deepPurple[600],
                                      ),
                                    ),

                                    const SizedBox(height: 30),

                                    FutureBuilder<List<Weather>>(
                                      future: dailyForecast,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return const Text('Error loading daily forecast');
                                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                          return const Text('No forecast data');
                                        }

                                        final days = snapshot.data!;
                                        return SizedBox(
                                          height: 140,
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: days.length,
                                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                                            itemBuilder: (context, index) {
                                              final day = days[index];
                                              final dayName = DateFormat.E().format(day.dateTime);
                                              return Container(
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.7),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                padding: const EdgeInsets.all(12),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(dayName,
                                                        style: roundedFont.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Colors.deepPurple[700],
                                                        )),
                                                    const SizedBox(height: 6),
                                                    Image.network(day.iconUrl, width: 40, height: 40),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      '${day.temperature.toStringAsFixed(0)}°${isCelsius ? 'C' : 'F'}',
                                                      style: roundedFont.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16,
                                                        color: Colors.deepPurple[700],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),

                                    const SizedBox(height: 30),

                                    FutureBuilder<List<Weather>>(
                                      future: hourlyForecast,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return const Text('Error loading hourly forecast');
                                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                          return const Text('No hourly data');
                                        }

                                        final hours = snapshot.data!;
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Hourly Forecast',
                                              style: roundedFont.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.deepPurple[800],
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            SizedBox(
                                              height: 120,
                                              child: ListView.separated(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: hours.length,
                                                separatorBuilder: (_, __) => const SizedBox(width: 12),
                                                itemBuilder: (context, index) {
                                                  final hour = hours[index];
                                                  final timeStr = DateFormat.jm().format(hour.dateTime);
                                                  return Container(
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withOpacity(0.7),
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    padding: const EdgeInsets.all(10),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(timeStr,
                                                            style: roundedFont.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.deepPurple[700],
                                                            )),
                                                        const SizedBox(height: 6),
                                                        Image.network(hour.iconUrl, width: 40, height: 40),
                                                        const SizedBox(height: 6),
                                                        Text(
                                                          '${hour.temperature.toStringAsFixed(0)}°${isCelsius ? 'C' : 'F'}',
                                                          style: roundedFont.copyWith(
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.deepPurple[700],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}