class WeatherData {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String description;
  final String weatherMain;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.description,
    required this.weatherMain,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      description: json['weather'][0]['description'] ?? '',
      weatherMain: json['weather'][0]['main'] ?? '',
    );
  }
}

