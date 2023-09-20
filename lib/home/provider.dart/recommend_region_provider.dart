import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recommmendRegionProvider =
    StateNotifierProvider<RecommendRegionNotifier, Map<String, dynamic>>((ref) {
  return RecommendRegionNotifier();
});

class RecommendRegionNotifier extends StateNotifier<Map<String, dynamic>> {
  RecommendRegionNotifier() : super({}) {
    getRegionData();
  }

  final List<String> regionKeywordList = [
    '서울',
    '서울특별시',
    '부산',
    '부산광역시',
    '제주',
    '제주도',
    '대구광역시',
    '경주',
    '포항'
  ];

  Future<void> getRegionData() async {
    state = {};

    int index = Random().nextInt(regionKeywordList.length);
    Map<String, dynamic> result = {'region': regionKeywordList[index]};
    final Dio dio = Dio();

    final Map<String, dynamic> params = {
      "numOfRows": 100,
      "pageNo": 1,
      "MobileOS": Platform.isIOS ? "IOS" : "AND",
      "MobileApp": "keyket",
      "_type": "json",
      "keyword": regionKeywordList[index],
      "serviceKey": dotenv.env['PUBLIC_DATA_API_KEY']
    };

    try {
      Response response = await dio
          .get(
            'https://apis.data.go.kr/B551011/PhotoGalleryService1/gallerySearchList1',
            queryParameters: params,
          )
          .timeout(const Duration(milliseconds: 1500));

      if (response.statusCode == 200) {
        List<dynamic> items =
            response.data['response']['body']['items']['item'];

        Random random = Random();
        Set<int> randomIndex = {};

        while (randomIndex.length < 9 && randomIndex.length < items.length) {
          randomIndex.add(random.nextInt(items.length));
        }

        List<String> images = [];
        List<String> titles = [];

        for (int index in randomIndex) {
          var item = items[index];
          images.add(item['galWebImageUrl']);
          titles.add(item['galTitle']);
        }
        result['images'] = images;
        result['titles'] = titles;

        state = result;
      } else {
        throw Exception('Failed to load data from the API');
      }
    } catch (e) {
      if (e is TimeoutException) {
        print("Connection Timeout Occurred!");
      } else {
        print(e);
      }
      loadDefaultImagesAndTitles();
    }
  }

  void loadDefaultImagesAndTitles() {
    List<String> defaultTitles = [
      "낙동강유채축제",
      "늦가을의 우포늪",
      "만년교의 봄",
      "만년교의 쥐불놀이",
      "아침을 여는 우포",
      "우포 지킴이",
      "우포늪 일출",
      "우포의 아침",
      "우포의 어부",
    ];

    defaultTitles.shuffle();

    List<String> defaultImages =
        defaultTitles.map((title) => 'asset/img/region/$title.jpg').toList();

    state = {
      'region': '창녕',
      'images': defaultImages,
      'titles': defaultTitles,
    };
  }
}
