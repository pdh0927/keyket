import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keyket/recommend/provider/selected_filter_provider.dart';

final firestore = FirebaseFirestore.instance;

// final recommendDataLoaderProvider = Provider<void>((ref) {
// RecommendRegion? selectedRegion = ref.watch(selectedRegionFilterProvider);
// List<RecommendTheme> selectedThemes =
//     ref.watch(selectedThemeFilterListProvider);

//   ref
//       .read(recommendItemListProvider.notifier)
//       .getRecommendData(selectedRegion, selectedThemes);
// });

final recommendItemListProvider =
    StateNotifierProvider<RecommendItemListNotifier, List<RecommendItemModel>>(
        (ref) => RecommendItemListNotifier(ref)); // class를 privider로

class RecommendItemListNotifier
    extends StateNotifier<List<RecommendItemModel>> {
  RecommendItemListNotifier(
      ref) // ShoppingListNotifier 초기화(StateNotifier에 기본으로 있는 state를 super 안의 값으로 초기화)
      : super([]) {
    RecommendRegion? selectedRegion = ref.watch(selectedRegionFilterProvider);
    List<RecommendTheme> selectedThemes =
        ref.watch(selectedThemeFilterListProvider);
    getRecommendData(selectedRegion, selectedThemes);
  }

  void getRecommendData(RecommendRegion? selectedRegion,
      List<RecommendTheme> selectedThemes) async {
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
        List<String> themeStrings = selectedThemes
            .map((theme) => theme.toString().split('.').last)
            .toList();
        query = query.where('theme', whereIn: themeStrings);
      }
      QuerySnapshot<Map<String, dynamic>> docList = await query.get();

      for (var doc in docList.docs) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;

        recommendItemList.add(RecommendItemModel.fromJson(data));
      }
    } catch (e) {
      print(e);
    }

    state = recommendItemList;
  }
}
