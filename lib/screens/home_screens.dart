// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:weather/services/weather.dart';
import 'package:weather/utils/location_helper.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
    this.lat,
    this.long,
  }) : super(key: key);
  final lat;
  final long;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    myWeather = fetchWeather();
  }

  String API_KEY = 'YOUR API KEY';

  Future<Weather> fetchWeather() async {
    final resp = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${widget.lat}&lon=${widget.long}&lang=tr&appid=$API_KEY&units=metric'));

    if (resp.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(resp.body);

      return Weather.fromJson(json);
    } else {
      throw Exception('Veriler yüklenemedi...');
    }
  }

  late Future<Weather> myWeather;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      drawer: const Drawer(backgroundColor: Colors.amber),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffFEB054), Color(0xffFEA14E)])),
        child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: FutureBuilder(
              future: myWeather,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: districtMethod(
                                context,
                                '${snapshot.data!.name}',
                                '${snapshot.data!.sys['country']}'),
                          ),
                          Expanded(
                            child: Container(
                                child: Center(
                                    child: Text(
                              snapshot.data!.weather[0]['description']
                                  .toString()
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.white60),
                            ))),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          weatherIcon('${snapshot.data!.weather[0]['icon']}'),
                          degreeText(context,
                              '${snapshot.data!.main['temp'].toStringAsFixed(0)}°'),
                        ],
                      ),
                      ExtraCard(
                          cardText: 'Rüzgar',
                          icon: 'wind',
                          value: '${snapshot.data!.wind['speed']} km/s'),
                      SizedBox(
                        height: 10,
                      ),
                      ExtraCard(
                          icon: 'humidity',
                          cardText: 'Nem',
                          value: '${snapshot.data!.main['humidity']}%'),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Text('Veriler Alınırken Hata Oluştu');
                } else {
                  return SpinKitCircle(
                    color: Colors.white,
                  );
                }
              },
            )),
      ),
    );
  }

  Expanded degreeText(BuildContext context, String degree) {
    return Expanded(
      child: SizedBox(
        height: 250,
        child: Center(
          child: Text(
            degree,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }

  Expanded weatherIcon(String iconCode) {
    return Expanded(
        child: SizedBox(
      height: 250,
      child: WeatherIconNetwork().networkImage(iconCode),
    ));
  }

  Column districtMethod(BuildContext context, String city, String country) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          city ?? 'Nan',
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          country ?? 'Nan',
          style: Theme.of(context).textTheme.headline4,
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ExtraCard extends StatelessWidget {
  const ExtraCard({
    Key? key,
    required this.icon,
    required this.cardText,
    required this.value,
  }) : super(key: key);
  final String icon;
  final String cardText;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.3),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Row(
                children: [
                  Container(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: ImagePath().assetImage(icon),
                      )),
                  Container(
                      height: 100,
                      child: Center(
                        child: Text(
                          cardText,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ))
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                value,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@override
// TODO: implement wantKeepAlive
bool get wantKeepAlive => true;

class ImagePath {
  SvgPicture assetImage(String imageName) {
    return SvgPicture.asset(
      imagePath(imageName),
      height: 200,
      fit: BoxFit.contain,
    );
  }

  String imagePath(String imageName) {
    return 'assets/svg/$imageName.svg';
  }
}

class WeatherIconNetwork {
  Image networkImage(String iconCode) {
    return Image.network(imageUrl(iconCode));
  }

  String imageUrl(String iconCode) {
    return 'http://openweathermap.org/img/wn/$iconCode@4x.png';
  }
}
