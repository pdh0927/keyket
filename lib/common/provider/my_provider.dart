import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyket/common/component/compress_image.dart';
import 'package:keyket/common/model/user_model.dart';
import 'package:uuid/uuid.dart';

final myInformationProvider =
    StateNotifierProvider<MyInformationNotifer, UserModel?>((ref) {
  return MyInformationNotifer();
});

class MyInformationNotifer extends StateNotifier<UserModel?> {
  MyInformationNotifer() : super(null);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final DocumentSnapshot userDoc =
            await _firestore.collection('user').doc(user.uid).get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          data['id'] = userDoc.id;
          state = UserModel.fromJson(data);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void changeName(String nickname) async {
    state = state!.copyWith(nickname: nickname);

    await _firestore
        .collection('user')
        .doc(state!.id)
        .update({'nickname': nickname});
  }

  Future<void> changeImage(String imagePath) async {
    // 기존의 이미지가 있으면 삭제합니다.
    if (state!.image != '') {
      Reference photoRef = FirebaseStorage.instance.refFromURL(state!.image);
      await photoRef.delete();
    }

    if (imagePath != '') {
      // 이미지를 Firebase Storage에 업로드하고 Firestore에 이미지 URL을 저장합니다.
      String imageUrl = await _uploadImageToFirebase(imagePath, storage);

      // 변경된 이미지 URL을 modifiedBucketListModel의 이미지로 설정합니다.
      state = state!.copyWith(image: imageUrl);

      await _firestore
          .collection('user')
          .doc(state!.id)
          .update({'image': imageUrl});
    } else {
      state = state!.copyWith(image: '');

      await _firestore.collection('user').doc(state!.id).update({'image': ''});
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

  void resetState() {
    state = null;
  }
}

Future<String> _uploadImageToFirebase(
    String imagePath, FirebaseStorage storage) async {
  File? imageFile = File(imagePath);
  imageFile = await compressImage(imageFile: imageFile);
  String uniqueId = Uuid().v4();
  try {
    // 이미지를 Firebase Storage에 업로드하고 다운로드 URL을 가져옵니다.
    await storage.ref('images/$uniqueId').putFile(imageFile!);
    String downloadURL = await storage.ref('images/$uniqueId').getDownloadURL();
    return downloadURL;
  } catch (e) {
    // 이미지 업로드에 실패했습니다.
    print(e);
    return '';
  }
}
