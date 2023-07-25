import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/component/custom_alert_dialog.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';

final selectedRegionFilterProvider =
    StateNotifierProvider<SelectedFilterListNotifier, RecommendRegion?>(
        (ref) => SelectedFilterListNotifier());

class SelectedFilterListNotifier extends StateNotifier<RecommendRegion?> {
  SelectedFilterListNotifier() // ShoppingListNotifier 초기화(StateNotifier에 기본으로 있는 state를 super 안의 값으로 초기화)
      : super(null);

  void onSelected(RecommendRegion region) {
    state = region;
  }

  void deleteHashTag() {
    state = null;
  }
}

final selectedThemeFilterListProvider = StateNotifierProvider<
    SelectedThemeFilterListNotifier,
    List<RecommendTheme>>((ref) => SelectedThemeFilterListNotifier());

class SelectedThemeFilterListNotifier
    extends StateNotifier<List<RecommendTheme>> {
  SelectedThemeFilterListNotifier() // ShoppingListNotifier 초기화(StateNotifier에 기본으로 있는 state를 super 안의 값으로 초기화)
      : super([]);

  void onSelected(BuildContext context, RecommendTheme theme) {
    if (state.length >= 5) {
      showCustomAlertDialog(context, '테마 해쉬태그는 최대\n5개까지만 가능합니다.');
    } else {
      bool isDuplicate = state.contains(theme);

      if (!isDuplicate) {
        state = [...state, theme];
      }
    }
  }

  void deleteHashTag(RecommendTheme theme) {
    state.remove(theme);
    state = List.from(state);
  }
}
