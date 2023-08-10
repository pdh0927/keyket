import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/model/user_model.dart';

final myInformationProvider =
    StateNotifierProvider<MyInformationNotifer, UserModel?>((ref) {
  return MyInformationNotifer();
});

class MyInformationNotifer extends StateNotifier<UserModel?> {
  MyInformationNotifer() : super(null);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DocumentSnapshot userDoc =
          await _firestore.collection('user').doc(user.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        data['id'] = userDoc.id;
        state = UserModel.fromJson(data);
      }
    }
  }

  void setFixedBucket(String newBucketId) async {
    // 상태 업데이트
    state = state!.copyWith(fixedBucket: newBucketId);

    // Firestore에 데이터 업데이트
    try {
      await _firestore
          .collection('user')
          .doc(state!.id)
          .update({'fixedBucket': newBucketId});
    } catch (e) {
      print("Error updating user's fixed bucket: $e");
    }
  }
}
