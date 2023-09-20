import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

void apiTest() async {
  final Map<String, dynamic> params = {
    "numOfRows": 100,
    "pageNo": 1,
    "resultType": "json",
    "ServiceKey": dotenv.env['PUBLIC_DATA_API_KEY']
  };

  final Dio dio = Dio();

  try {
    Response response = await dio.get(
      "http://apis.data.go.kr/6260000/FestivalService/getFestivalKr",
      queryParameters: params,
    );
    Map<String, dynamic> decodedJson = json.decode(response.data);

    for (int i = 0; i < decodedJson['getFestivalKr']['item'].length; i++) {
      print(decodedJson['getFestivalKr']['item'][i]);
    }
    print(decodedJson['getFestivalKr']['item'].length);
  } catch (e) {
    print(e);
  }
}
