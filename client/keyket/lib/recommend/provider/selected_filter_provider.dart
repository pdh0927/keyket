import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/component/custom_alert_dialog.dart';

final selectedFilterListProvider = StateNotifierProvider<
    SelectedFilterListNotifier,
    List<Map<String, dynamic>>>((ref) => SelectedFilterListNotifier());

class SelectedFilterListNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  SelectedFilterListNotifier() // ShoppingListNotifier 초기화(StateNotifier에 기본으로 있는 state를 super 안의 값으로 초기화)
      : super([]);

  void onSelected(BuildContext context, String type, String value) {
    if (state.length >= 6) {
      showCustomAlertDialog(context, '해쉬태그는 최대\n6개까지만 가능합니다.');
    } else {
      bool isDuplicate =
          state.any((item) => item['type'] == type && item['value'] == value);

      if (!isDuplicate) {
        state = [
          ...state,
          {'type': type, 'value': value}
        ];
      }
    }
  }

  void deleteHashTag(String type, String value) {
    state = state
        .where(
            (element) => element['type'] != type || element['value'] != value)
        .toList();
  }
}
