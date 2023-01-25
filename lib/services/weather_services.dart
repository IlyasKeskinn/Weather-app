// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:weather/services/weather_model.dart';
import 'package:weather/utils/location_helper.dart';

abstract class IWeatherService {
  Future<List<WeatherModel>?> fetchWeatherItems();
}

class WeatherService implements IWeatherService {
  late final Dio _networkDio;

  WeatherService()
      : _networkDio = Dio(BaseOptions(
            baseUrl:
                'https://api.openweathermap.org/data/2.5/weather?lat=37.874641&lon=32.493156&appid=548a9758cf1b7c01606602d0711859f8&units=metric'));

  @override
  Future<List<WeatherModel>?> fetchWeatherItems() async {
    final resonse = await _networkDio.get('');
    try {
      if (resonse.statusCode == HttpStatus.ok) {
        final _datas = resonse.data;
        if (_datas is List) {
          return _datas.map((e) => WeatherModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
