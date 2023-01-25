class WeatherModel {
  final String name;
  var main;
  var wind;
  var weather;

  WeatherModel(
      {required this.main,
      required this.name,
      required this.weather,
      required this.wind});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      name: json['name'],
      wind: json['wind'],
      weather: json['weather'],
      main: json['main'],
    );
  }
}
