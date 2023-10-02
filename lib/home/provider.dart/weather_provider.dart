import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/home/provider.dart/index_provider.dart';

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, Map<String, dynamic>>((ref) {
  final index = ref.watch(indexProvider);
  return WeatherNotifier(index);
});

class WeatherNotifier extends StateNotifier<Map<String, dynamic>> {
  WeatherNotifier(this.index) : super({}) {
    getWeatherData();
  }

  final int index;

  final List<String> regionIdList = [
    '61',
    '61',
    '307',
    '307',
    '387',
    '387',
    '316',
    '122',
    '123',
    '240'
  ];

  Future<void> getWeatherData() async {
    state = {};

    DateTime now = DateTime(2023, 10, 2);
    int yyyymmdd =
        int.parse('${now.year}${_twoDigit(now.month)}${_twoDigit(now.day)}');

    final Map<String, dynamic> params = {
      'ServiceKey': dotenv.env['PUBLIC_DATA_API_KEY'],
      'pageNo': '1',
      'numOfRows': '1',
      'dataType': 'json',
      'CURRENT_DATE': yyyymmdd.toString(),
      'HOUR': '24',
      'COURSE_ID': regionIdList[index]
    };

    final Dio dio = Dio();

    try {
      Response response = await dio.get(
        'http://apis.data.go.kr/1360000/TourStnInfoService1/getTourStnVilageFcst1',
        queryParameters: params,
      );

      state = response.data['response']['body']['items']['item'][0];
    } catch (e) {
      print(e);
    }
  }

  String _twoDigit(int n) {
    if (n >= 10) return n.toString();
    return '0$n';
  }
}
