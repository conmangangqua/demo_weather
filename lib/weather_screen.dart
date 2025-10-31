import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherData? _weatherData;
  bool _isLoading = false;
  String _errorMessage = '';
  final TextEditingController _cityController = TextEditingController();

  // Sử dụng OpenWeatherMap API (miễn phí)
  // Bạn cần đăng ký API key tại https://openweathermap.org/api
  // Tạm thời dùng demo API key, nên thay bằng API key của bạn
  final String _apiKey = '22b1411f379302f3f1c6084fb29cff23';
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  @override
  void initState() {
    super.initState();
    _cityController.text = 'Hanoi';
    _fetchWeather('Hanoi');
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final url = Uri.parse(
        '$_baseUrl?q=$city&appid=$_apiKey&units=metric&lang=vi',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _weatherData = WeatherData.fromJson(data);
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'Không tìm thấy thành phố: $city';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Lỗi khi lấy dữ liệu thời tiết';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi kết nối: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _searchWeather() {
    final city = _cityController.text.trim();
    if (city.isNotEmpty) {
      _fetchWeather(city);
    }
  }

  String _getWeatherIcon(String main) {
    switch (main.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          hintText: 'Nhập tên thành phố',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _searchWeather(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _searchWeather,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),

              // Weather content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : _errorMessage.isNotEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _errorMessage,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : _weatherData == null
                            ? const Center(
                                child: Text(
                                  'Không có dữ liệu',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    // City name
                                    Text(
                                      _weatherData!.cityName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Date
                                    Text(
                                      DateFormat('EEEE, dd MMMM yyyy', 'vi')
                                          .format(DateTime.now()),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 32),

                                    // Weather icon and temperature
                                    Text(
                                      _getWeatherIcon(
                                        _weatherData!.weatherMain,
                                      ),
                                      style: const TextStyle(fontSize: 100),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      '${_weatherData!.temperature.toStringAsFixed(1)}°C',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 64,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _weatherData!.description,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 48),

                                    // Weather details
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          _buildDetailRow(
                                            Icons.thermostat,
                                            'Cảm nhận như',
                                            '${_weatherData!.feelsLike.toStringAsFixed(1)}°C',
                                          ),
                                          const Divider(color: Colors.white54),
                                          _buildDetailRow(
                                            Icons.water_drop,
                                            'Độ ẩm',
                                            '${_weatherData!.humidity}%',
                                          ),
                                          const Divider(color: Colors.white54),
                                          _buildDetailRow(
                                            Icons.air,
                                            'Tốc độ gió',
                                            '${_weatherData!.windSpeed.toStringAsFixed(1)} m/s',
                                          ),
                                          const Divider(color: Colors.white54),
                                          _buildDetailRow(
                                            Icons.compress,
                                            'Áp suất',
                                            '${_weatherData!.pressure} hPa',
                                          ),
                                        ],
                                      ),
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
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

