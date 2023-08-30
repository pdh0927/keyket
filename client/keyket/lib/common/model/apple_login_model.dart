import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
        '딱딱한 딱따구리',
        '밍밍한 수박',
        '춤추는 곰돌이',
        '20살 어린이',
        '배고픈 돼지',
        '잠오는 잠만보',
      ];

      var seed = DateTime.now().millisecondsSinceEpoch;
      var random = Random(seed);

      // 랜덤하게 인덱스 선택
      int randomIndex = random.nextInt(nicknames.length);

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

  @override
  Future<bool> deleteUser() async {
    try {
      // Apple 로그인을 통해 새로운 인증 토큰을 얻습니다.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Firebase용 AuthCredential 객체를 생성합니다.
      final AuthCredential firebaseCredential =
          OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
      );

      // Firebase에 재인증 요청을 합니다.
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(firebaseCredential);

      FirebaseAuth auth = FirebaseAuth.instance;
      String userId = auth.currentUser!.uid;

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection("user").doc(userId).delete();

      // 사용자를 Firebase에서 삭제합니다.
      await FirebaseAuth.instance.currentUser!.delete();

      print('Successfully deleted user account after Apple reauthentication.');

      return true;
    } catch (e) {
      print('Error deleting user account: $e');
      return false;
    }
  }
}
