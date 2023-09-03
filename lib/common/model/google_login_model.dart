import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keyket/common/model/main_view_model.dart';
import 'package:keyket/common/model/social_login.dart';

class GoogleLoginModel implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
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
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    return true;
  }

  @override
  Future<bool> deleteUser() async {
    try {
      // final GoogleSignIn googleSignIn = GoogleSignIn();
      // final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // if (googleUser != null) {
      // final GoogleSignInAuthentication googleAuth =
      //     await googleUser.authentication;

      // final AuthCredential firebaseCredential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );

      // // Firebase에 재인증 요청을 합니다.
      // await FirebaseAuth.instance.currentUser!
      //     .reauthenticateWithCredential(firebaseCredential);

      FirebaseAuth auth = FirebaseAuth.instance;
      String userId = auth.currentUser!.uid;

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection("user").doc(userId).delete();

      // 사용자를 Firebase에서 삭제합니다.
      await FirebaseAuth.instance.currentUser!.delete();

      print('Successfully deleted user account after Google reauthentication.');

      return true;
      // }
      // return false;
    } catch (e) {
      print('Error deleting user account: $e');
      return false;
    }
  }
}
