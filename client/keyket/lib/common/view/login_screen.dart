import 'package:flutter/material.dart';
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
  bool isInstalled = await isKakaoTalkInstalled();
  OAuthToken token = isInstalled
      ? await UserApi.instance.loginWithKakaoTalk()
      : await UserApi.instance.loginWithKakaoAccount();
  // TODO: Handle the token
  print(token);

  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (route) => false);
}
