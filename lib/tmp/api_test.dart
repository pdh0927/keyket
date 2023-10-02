import 'package:dio/dio.dart';

void apiTest() async {
  DateTime now = DateTime(2023, 10, 2);
  int yyyymmdd =
      int.parse('${now.year}${_twoDigit(now.month)}${_twoDigit(now.day)}');

  final Map<String, dynamic> params = {
    'ServiceKey':
        'xBDpjEAn5RzvzNhwBgo/BTjxXFd07srl7FzKbHOXh0liVSTWzSEF/8fFK9in+oJNI26MkaHvUyhPQ067LYXuKQ==',
    'pageNo': '1',
    'numOfRows': '1',
    'dataType': 'json',
    'CURRENT_DATE': yyyymmdd.toString(),
    'HOUR': '24',
    'COURSE_ID': '122'
  };

  final Dio dio = Dio();

  try {
    Response response = await dio.get(
      'http://apis.data.go.kr/1360000/TourStnInfoService1/getTourStnVilageFcst1',
      queryParameters: params,
    );
    // print(response.statusCode);
    // Map<String, dynamic> decodedJson = json.decode(response.data);
    // print(decodedJson);
    print(response.data['response']['body']['items']['item'][0]);
  } catch (e) {
    print(e);
  }
}

String _twoDigit(int n) {
  if (n >= 10) return n.toString();
  return '0$n';
}
