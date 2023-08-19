import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:keyket/common/model/main_view_model.dart';
import 'package:keyket/common/model/social_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginModel implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      List<String> nicknames = [
        '여행돌이',
        '꿈꾸는 어린왕자',
        '따뜻한 얼음',
        '까칠한 까치',
        '차가운 불',
        '딱딱한 딱다구리',
        '밍밍한 수박',
        '춤추는 곰돌이',
        '20살 어린이',
        '배고픈 돼지',
        '잠오는 잠만보'
      ];

      // 랜덤하게 인덱스 선택
      int randomIndex = Random().nextInt(nicknames.length);

      // 선택된 닉네임
      String selectedNickname = nicknames[randomIndex];

      await createUserInFirestore(userCredential.user!.uid, selectedNickname);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    return true;
  }
}
