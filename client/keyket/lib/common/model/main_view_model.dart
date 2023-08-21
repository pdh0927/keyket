import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:keyket/common/model/social_login.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';

class MainViewModel {
  final SocialLogin _socialLogin;

  MainViewModel(this._socialLogin);

  Future<bool> login() async {
    bool isSucessed = await _socialLogin.login();
    if (isSucessed) {
      return true;
    } else {
      return false;
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    await FirebaseAuth.instance.signOut();
  }
}

// 8자리 UUID 생성 함수
String generateShortUUID() {
  var uuid = const Uuid().v4(); // UUID 생성
  var bytes = utf8.encode(uuid); // UUID를 byte로 변환
  var digest = sha256.convert(bytes); // sha256으로 해시

  return digest.toString().substring(0, 8); // 해시값의 첫 8자리 반환
}

Future<void> createUserInFirestore(String id, String nickname) async {
  final firestore = FirebaseFirestore.instance;
  final userRef = firestore.collection('user').doc(id);

  await firestore.runTransaction((transaction) async {
    final userSnapshot = await transaction.get(userRef);
    String inviteCode = generateShortUUID();
    QuerySnapshot<Map<String, dynamic>> inviteCodeSnapshot = await firestore
        .collection('user')
        .where('inviteCode', isEqualTo: inviteCode)
        .get();

    // inviteCode의 중복을 피하기 위한 반복문
    while (inviteCodeSnapshot.docs.isNotEmpty) {
      inviteCode = generateShortUUID();
      inviteCodeSnapshot = await firestore
          .collection('user')
          .where('inviteCode', isEqualTo: inviteCode)
          .get();
    }

    if (!userSnapshot.exists) {
      // 사용자 데이터에 초대 코드를 포함하여 설정
      transaction.set(userRef, {
        'nickname': nickname,
        'image': '',
        'fixedBucket': '',
        'inviteCode': inviteCode
      });
      print('User added to Firestore.');
    } else {
      print('User already exists.');
    }
  });
}
