import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keyket/recommend/provider/selected_filter_provider.dart';

final firestore = FirebaseFirestore.instance;

final recommendItemListProvider =
    StateNotifierProvider<RecommendItemListNotifier, List<RecommendItemModel>>(
        (ref) {
  RecommendRegion? selectedRegion = ref.watch(selectedRegionFilterProvider);
  List<RecommendTheme> selectedThemes =
      ref.watch(selectedThemeFilterListProvider);
  return RecommendItemListNotifier(selectedRegion, selectedThemes);
}); // class를 privider로

class RecommendItemListNotifier
    extends StateNotifier<List<RecommendItemModel>> {
  RecommendItemListNotifier(this.selectedRegion, this.selectedThemes)
      : super([]) {
    getRecommendData(selectedRegion, selectedThemes);
  }
  RecommendRegion? selectedRegion;
  List<RecommendTheme> selectedThemes;

  DocumentSnapshot? lastVisibleDocument;
  bool isLastPage = false;

  void getRecommendData(RecommendRegion? selectedRegion,
      List<RecommendTheme> selectedThemes) async {
    int getCount = 10;

    if (isLastPage) {
      return; // 마지막 페이지라면 추가 데이터를 가져오지 않습니다.
    }

    List<RecommendItemModel> recommendItemList = [];

    try {
      Query<Map<String, dynamic>> query = firestore.collection('recommend');

      // selectedRegion이 Null이 아닐 경우 where 조건 추가
      if (selectedRegion != null) {
        query = query.where('region',
            isEqualTo: selectedRegion.toString().split('.').last);
      }

      // themeStrings이 빈 배열이 아닐 경우 where 조건 추가
      if (selectedThemes.isNotEmpty) {
        List<String> themeStringList = selectedThemes
            .map((theme) => theme.toString().split('.').last)
            .toList();
        query = query.where('theme', arrayContainsAny: themeStringList);
      }

      if (lastVisibleDocument != null) {
        query = query.startAfterDocument(lastVisibleDocument!);
      }

      query = query.limit(getCount); // 원하는 갯수만큼만 가져옴

      QuerySnapshot<Map<String, dynamic>> docList = await query.get();

      for (var doc in docList.docs) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        recommendItemList.add(RecommendItemModel.fromJson(data));
      }

      if (docList.docs.isNotEmpty) {
        lastVisibleDocument = docList.docs.last;
        if (docList.docs.length < getCount) {
          isLastPage = true;
        }
      } else {
        isLastPage = true;
      }

      state = [...state, ...recommendItemList]; // 기존의 아이템들에 새로운 아이템들을 추가합니다.
    } catch (e) {
      print(e);
    }
  }

  bool fetchMoreData() {
    if (!isLastPage) {
      getRecommendData(selectedRegion, selectedThemes);
    }
    return isLastPage;
  }
}
