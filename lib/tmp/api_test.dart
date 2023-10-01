import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

void apiTest() async {
  final Map<String, dynamic> params = {
    'serviceKey':
        'xBDpjEAn5RzvzNhwBgo/BTjxXFd07srl7FzKbHOXh0liVSTWzSEF/8fFK9in+oJNI26MkaHvUyhPQ067LYXuKQ==',
    'pageNo': '1',
    'numOfRows': '10',
    'SIDO_NM': '제주',
    'resultType': 'json'
  };

  final Dio dio = Dio();

  try {
    Response response = await dio.get(
      'http://apis.data.go.kr/1192000/service/OceansBeachInfoService1/getOceansBeachInfo1',
      queryParameters: params,
    );
    Map<String, dynamic> decodedJson = json.decode(response.data);

    for (int i = 0; i < decodedJson['getOceansBeachInfo']['item'].length; i++) {
      print(decodedJson['getOceansBeachInfo']['item'][i]);
    }
    print(decodedJson['getOceansBeachInfo']['item'].length);
  } catch (e) {
    print(e);
  }
}
