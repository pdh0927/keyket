import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:keyket/common/model/firebase_auth_remote_data_source.dart';
import 'package:keyket/common/model/social_login.dart';

class MainViewModel {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  final SocialLogin _socialLogin;
  bool isLogin = false;
  kakao.User? user;

  MainViewModel(this._socialLogin);

  Future<bool> login() async {
    isLogin = await _socialLogin.login();

    if (isLogin) {
      user = await kakao.UserApi.instance.me();
      final customToken = await _firebaseAuthDataSource.createCustomUserToken({
        'uid': user!.id.toString(),
        'displayname': user!.kakaoAccount!.profile!.nickname,
      });

      await FirebaseAuth.instance.signInWithCustomToken(customToken);

      // JSON에서 필요한 정보 추출
      String kakaoId = user!.id.toString();
      String nickname = user!.kakaoAccount!.profile!.nickname!;

      // Firestore에 사용자 데이터 저장
      await _createUserInFirestore(kakaoId, nickname);

      return true;
    }
    return false;
  }

  Future logout() async {
    await _socialLogin.logout();
    await FirebaseAuth.instance.signOut();
    isLogin = false;
    user = null;
  }
}

Future<void> _createUserInFirestore(String id, String nickname) async {
  final firestore = FirebaseFirestore.instance;
  final userRef = firestore.collection('user').doc(id);

  await firestore.runTransaction((transaction) async {
    final userSnapshot = await transaction.get(userRef);

    if (!userSnapshot.exists) {
      transaction.set(userRef, {
        'nickname': nickname,
        'image': '',
        'fixedBucket': '',
      });
      print('User added to Firestore.');
    } else {
      print('User already exists.');
    }
  });
}
