import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/bucket/model/custom_item_model.dart';
import 'package:keyket/common/model/user_model.dart';
import 'package:keyket/recommend/model/recommend_item_model.dart';

final bucketListUserProvider =
    StateNotifierProvider<BucketListUserNotifier, Map<String, List<UserModel>>>(
        (ref) {
  return BucketListUserNotifier();
});

class BucketListUserNotifier
    extends StateNotifier<Map<String, List<UserModel>>> {
  BucketListUserNotifier() : super({});

  void addBucketListUsers(String key, List<UserModel> users) {
    state[key] = users;
    state = {...state};
  }

  void addUserToBucketList(String key, UserModel user) {
    // 해당 key가 이미 존재하는지 확인
    if (state.containsKey(key)) {
      state[key]!.add(user); // UserModel을 기존 리스트에 추가
    } else {
      state[key] = [user]; // 새로운 리스트 생성
    }
    state = {...state};
  }

  void removeUsersNotInIdList(String key, List<String> userIds) {
    if (state.containsKey(key)) {
      state[key]!.removeWhere((user) => !userIds.contains(user.id));
      state = {...state};
    }
  }
}

final customBucketListItemProvider = StateNotifierProvider<
    BucketListCustomItemNotifier, Map<String, CustomItems>>((ref) {
  return BucketListCustomItemNotifier();
});

class BucketListCustomItemNotifier
    extends StateNotifier<Map<String, CustomItems>> {
  BucketListCustomItemNotifier() : super({});

  void addCustomItemToBucketList(
      String key, CustomItemModel customItem, bool isComplete) {
    if (!state.containsKey(key)) {
      state[key] = CustomItems(completeItems: [], uncompleteItems: []);
    }

    if (isComplete) {
      state[key]!.completeItems.add(customItem);
    } else {
      state[key]!.uncompleteItems.add(customItem);
    }

    state = {...state};
  }

  void addCustomItemsToBucketList(String key, CustomItems customItems) {
    state[key] = customItems;
    state = {...state};
  }

  void moveItemToUncompleted(String key, CustomItemModel item) {
    if (state.containsKey(key)) {
      // 아이템이 완료 항목 리스트에 있는지 확인하고, 있다면 해당 아이템을 삭제
      int completedIndex = state[key]!.completeItems.indexOf(item);
      if (completedIndex != -1) {
        state[key]!.completeItems.removeAt(completedIndex);
        // 삭제한 아이템을 미완료 항목 리스트에 추가
        state[key]!.uncompleteItems.add(item);
      }

      state = {...state};
    }
  }

  void replaceCustomItemsInBucketList(String key, CustomItems newCustomItems) {
    if (state.containsKey(key)) {
      state[key] = newCustomItems;
      state = {...state};
    }
  } // 아이템을 미완료 항목 리스트에서 완료 항목 리스트로 이동

  void moveToCompleted(String bucketId, String itemId) {
    final items = state[bucketId];

    if (items != null) {
      final itemToMove =
          items.uncompleteItems.firstWhere((item) => item.id == itemId);

      items.uncompleteItems.remove(itemToMove);
      items.completeItems.add(itemToMove);
      state = {...state};
    }
  }

// 아이템을 완료 항목 리스트에서 미완료 항목 리스트로 이동
  void moveToUncompleted(String bucketId, String itemId) {
    final items = state[bucketId];

    if (items != null) {
      final itemToMove =
          items.completeItems.firstWhere((item) => item.id == itemId);

      items.completeItems.remove(itemToMove);
      items.uncompleteItems.add(itemToMove);
      state = {...state};
    }
  }
}

final recommendBucketListItemProvider = StateNotifierProvider<
    BucketListRecommendItemNotifier, Map<String, RecommendItems>>((ref) {
  return BucketListRecommendItemNotifier();
});

class BucketListRecommendItemNotifier
    extends StateNotifier<Map<String, RecommendItems>> {
  BucketListRecommendItemNotifier() : super({});

  void addRecommendItemToBucketList(
      String key, RecommendItemModel recommendItem, bool isComplete) {
    if (!state.containsKey(key)) {
      state[key] = RecommendItems(completeItems: [], uncompleteItems: []);
    }

    if (isComplete) {
      state[key]!.completeItems.add(recommendItem);
    } else {
      state[key]!.uncompleteItems.add(recommendItem);
    }

    state = {...state};
  }

  void addRecommendItemsToBucketList(
      String key, RecommendItems recommendItems) {
    state[key] = recommendItems;
    state = {...state};
  }

  void replaceRecommendItemsInBucketList(
      String key, RecommendItems newRecommendsItems) {
    if (state.containsKey(key)) {
      state[key] = newRecommendsItems;
      state = {...state};
    }
  }

  // 아이템을 미완료 항목 리스트에서 완료 항목 리스트로 이동
  void moveToCompleted(String bucketId, String itemId) {
    final items = state[bucketId];

    if (items != null) {
      final itemToMove = items.uncompleteItems.firstWhere(
        (item) => item.id == itemId,
      );

      items.uncompleteItems.remove(itemToMove);
      items.completeItems.add(itemToMove);
      state = {...state};
    }
  }

  // 아이템을 완료 항목 리스트에서 미완료 항목 리스트로 이동
  void moveToUncompleted(String bucketId, String itemId) {
    final items = state[bucketId];

    if (items != null) {
      final itemToMove =
          items.completeItems.firstWhere((item) => item.id == itemId);

      items.completeItems.remove(itemToMove);
      items.uncompleteItems.add(itemToMove);
      state = {...state};
    }
  }
}
