import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:keyket/common/layout/default_layout.dart';

import 'package:keyket/common/view/splash_screen.dart';

enum LoginPlatform {
  kakao,
  none, // logout
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child:
          Center(child: _loginButton('kakaologin', () => onTapFuture(context))),
    );
  }
}

Widget _loginButton(String path, VoidCallback onTap) {
  return Card(
    elevation: 18.0,
    shape: const CircleBorder(),
    clipBehavior: Clip.antiAlias,
    child: Ink.image(
      image: AssetImage('asset/img/$path.png'),
      width: 100,
      height: 100,
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(35.0),
        ),
        onTap: onTap,
      ),
    ),
  );
}

Future<void> onTapFuture(BuildContext context) async {
  // 카카오톡 실행 가능 여부 확인
  // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
  if (await isKakaoTalkInstalled()) {
    try {
      await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false);
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');

      // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
      // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
      if (error is PlatformException && error.code == 'CANCELED') {
        return;
      }
      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const SplashScreen()),
            (route) => false);
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  } else {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false);
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }
}