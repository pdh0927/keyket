import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:keyket/common/model/social_login.dart';
import 'package:keyket/common/model/user_model.dart';

class KaKaoLoginModel implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      // 카카오톡 실행 가능 여부 확인
      // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
      if (await isKakaoTalkInstalled()) {
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          final url = Uri.https('kapi.kakao.com', '/v2/user/me');

          final response = await http.get(
            url,
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
            },
          );

          final profileInfo = json.decode(response.body);

          // JSON에서 필요한 정보 추출
          // JSON에서 필요한 정보 추출
          String kakaoId = profileInfo['id'].toString();
          String name = profileInfo['properties']['nickname'];
          String image = profileInfo['properties']['thumbnail_image'];

          // Firestore에 사용자 데이터 저장
          await _createUserInFirestore(kakaoId, name, image);

          return true;
        } catch (error) {
          print('카카오톡으로 로그인 실패 $error');

          // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
          // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
          if (error is PlatformException && error.code == 'CANCELED') {
            return false;
          }
          // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
          try {
            OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
            final url = Uri.https('kapi.kakao.com', '/v2/user/me');
            final response = await http.get(
              url,
              headers: {
                HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
              },
            );

            final profileInfo = json.decode(response.body);

            // JSON에서 필요한 정보 추출
            String kakaoId = profileInfo['id'].toString();
            String name = profileInfo['properties']['nickname'];
            String image = profileInfo['properties']['thumbnail_image'];

            // Firestore에 사용자 데이터 저장
            await _createUserInFirestore(kakaoId, name, image);

            return true;
          } catch (error) {
            print('카카오계정으로 로그인 실패 $error');
            return false;
          }
        }
      } else {
        // 카카오톡 설치가 안되어 있어서 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();

          // 토큰 저장
          TokenManagerProvider.instance.manager.setToken(token);

          final url = Uri.https('kapi.kakao.com', '/v2/user/me');
          final response = await http.get(
            url,
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
            },
          );

          final profileInfo = json.decode(response.body);

          // JSON에서 필요한 정보 추출
          String kakaoId = profileInfo['id'].toString();
          String name = profileInfo['properties']['nickname'];
          String image = profileInfo['properties']['thumbnail_image'];

          // Firestore에 사용자 데이터 저장
          await _createUserInFirestore(kakaoId, name, image);

          return true;
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          return false;
        }
      }
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

Future<void> _createUserInFirestore(
    String kakaoId, String name, String image) async {
  var counterRef =
      FirebaseFirestore.instance.collection('user_count').doc('userCounter');
  var userRef = FirebaseFirestore.instance.collection('user');

  DocumentSnapshot userSnapshot = await userRef.doc(kakaoId).get();

  if (userSnapshot.exists) {
    // 이미 존재하는 사용자인 경우 종료
    print('User already exists.');
    return;
  }

  FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot counterSnapshot = await transaction.get(counterRef);

    if (!counterSnapshot.exists) {
      throw Exception('User counter does not exist');
    } else {
      Map<String, dynamic> counterData =
          counterSnapshot.data() as Map<String, dynamic>;
      int updatedCount = counterData['count'] + 1;
      transaction.update(counterRef, {'count': updatedCount});

      UserModel user = UserModel(
        kakaoId: kakaoId,
        nickname: name,
        image: image,
        inviteCode: updatedCount,
      );

      transaction.set(userRef.doc(kakaoId), user.toJson());
    }
  });
}
