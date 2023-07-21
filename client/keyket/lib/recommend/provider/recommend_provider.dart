import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

final recommendItemListProvider =
    StateNotifierProvider<RecommendItemListNotifier, List<RecommendItemModel>>(
        (ref) => RecommendItemListNotifier()); // class를 privider로

class RecommendItemListNotifier
    extends StateNotifier<List<RecommendItemModel>> {
  RecommendItemListNotifier() // ShoppingListNotifier 초기화(StateNotifier에 기본으로 있는 state를 super 안의 값으로 초기화)
      : super([]) {
    getInitData();
  }

  void getInitData() async {
    List<RecommendItemModel> recommendItemList = [];

    try {
      QuerySnapshot<Map<String, dynamic>> doc_list =
          await firestore.collection('recommend').get();

      for (var doc in doc_list.docs) {
        // 보완 필요
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;

        recommendItemList.add(RecommendItemModel.fromJson(data));
      }
    } catch (e) {
      print(e);
    }

    state = recommendItemList;
    print(state);
  }
}
