import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:keyket/common/model/firebase_auth_remote_data_source.dart';
import 'package:keyket/common/model/main_view_model.dart';
import 'package:keyket/common/model/social_login.dart';
import 'package:http/http.dart' as http;

class KaKaoLoginModel implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      // 카카오톡 실행 가능 여부 확인
      // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
      if (await kakao.isKakaoTalkInstalled()) {
        try {
          kakao.OAuthToken token =
              await kakao.UserApi.instance.loginWithKakaoTalk();

          // 토큰 저장
          kakao.TokenManagerProvider.instance.manager.setToken(token);
          await loginProcess();

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
            kakao.OAuthToken token =
                await kakao.UserApi.instance.loginWithKakaoAccount();

            // 토큰 저장
            kakao.TokenManagerProvider.instance.manager.setToken(token);
            await loginProcess();

            return true;
          } catch (error) {
            print('카카오계정으로 로그인 실패 $error');
            return false;
          }
        }
      } else {
        // 카카오톡 설치가 안되어 있어서 카카오계정으로 로그인
        try {
          kakao.OAuthToken token =
              await kakao.UserApi.instance.loginWithKakaoAccount();

          // 토큰 저장
          kakao.TokenManagerProvider.instance.manager.setToken(token);
          await loginProcess();

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

  loginProcess() async {
    kakao.User? user;
    user = await kakao.UserApi.instance.me();
    final firebaseAuthDataSource = FirebaseAuthRemoteDataSource();

    final customToken = await firebaseAuthDataSource.createCustomUserToken({
      'uid': user.id.toString(),
      'displayname': user.kakaoAccount!.profile!.nickname,
    });
    print(customToken);

    await FirebaseAuth.instance.signInWithCustomToken(customToken);

    // JSON에서 필요한 정보 추출
    String kakaoId = user.id.toString();
    String nickname = user.kakaoAccount!.profile!.nickname!;

    // Firestore에 사용자 데이터 저장
    await createUserInFirestore(kakaoId, nickname);
  }

  @override
  Future<bool> logout() async {
    try {
      await kakao.UserApi.instance.unlink();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> deleteUser() async {
    String functionURL =
        "https://us-central1-keyket-bc537.cloudfunctions.net/deleteUser";
    FirebaseAuth auth = FirebaseAuth.instance;
    String userId = auth.currentUser!.uid;

    try {
      final response = await http.post(
        Uri.parse(functionURL),
        body: jsonEncode({'uid': userId}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection("user").doc(userId).delete();
        await auth.signOut(); // 사용자 로그아웃

        if (responseData['success'] == true) {
          return true;
        }
      }
      print('Failed to delete user: ${response.body}');
      return false;
    } catch (error) {
      print('Error when trying to delete user: $error');
      return false;
    }
  }
}
