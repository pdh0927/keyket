import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:keyket/common/model/social_login.dart';

class KaKaoLoginModel implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      // 카카오톡 실행 가능 여부 확인
      // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
      if (await isKakaoTalkInstalled()) {
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();

          // 토큰 저장
          TokenManagerProvider.instance.manager.setToken(token);

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

            // 토큰 저장
            TokenManagerProvider.instance.manager.setToken(token);

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