import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather/services/weather_model.dart';
import 'package:weather/services/weather_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<WeatherModel>? _items;
  late final IWeatherService _weatherService;

  @override
  void initState() {
    super.initState();
    _weatherService = WeatherService();
    fetchItems();
  }

  Future<void> fetchItems() async {
    _items = await _weatherService.fetchWeatherItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      drawer: const Drawer(),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              districtMethod(context),
              Row(
                children: [weatherIcon(), degreeText(context)],
              ),
              ExtraCard(cardText: 'wind', icon: 'wind', value: '19'),
              SizedBox(
                height: 10,
              ),
              ExtraCard(icon: 'humidity', cardText: 'Humidity', value: '65'),
            ],
          ),
        ),
      ),
    );
  }

  Expanded degreeText(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 250,
        child: Center(
          child: Text(
            '20',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }

  Expanded weatherIcon() {
    return Expanded(
      child: SizedBox(height: 250, child: ImagePath().assetImage('cloudy')),
    );
  }

  Column districtMethod(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Konya,',
          style: Theme.of(context).textTheme.headline3,
        ),
        Text(
          'Türkiye',
          style: Theme.of(context).textTheme.headline4,
        )
      ],
    );
  }
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
          )
        ],
      ),
    );
  }
}

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
