class Weather {
  final String name;
  var main;
  var wind;
  var weather;
  var sys;

  Weather(
      {required this.main,
      required this.name,
      required this.sys,
      required this.weather,
      required this.wind});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        name: json['name'],
        wind: json['wind'],
        weather: json['weather'],
        main: json['main'],
        sys: json['sys']);
  }
}
