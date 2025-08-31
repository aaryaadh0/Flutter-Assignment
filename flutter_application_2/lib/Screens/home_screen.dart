import 'package:flutter/material.dart';
import '../service/weather_service.dart';
import '../models/weather_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  String _selectedCountry = 'Nepal';
  Weather? _weather;
  bool _isLoading = false;

  List<String> countries = ['Nepal', 'India', 'USA', 'UK', 'Japan'];

  Future<void> _loadWeather() async {
    setState(() => _isLoading = true);
    try {
      final data = await _weatherService.fetchWeather(_selectedCountry);
      setState(() => _weather = data);
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    _loadWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text("WeatherApp"),
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
        onRefresh: _loadWeather,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            DropdownButton<String>(
              value: _selectedCountry,
              items: countries.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCountry = val!;
                  _loadWeather();
                });
              },
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_weather != null)
              Column(
                children: [
                  Text(
                    "${_weather!.temperature}°C",
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(_weather!.description),
                ],
              )
            else
              const Center(child: Text("Failed to load weather")),
          ],
        ),
      ),
    );
  }
}
