import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:keyket/common/model/firebase_auth_remote_data_source.dart';
import 'package:keyket/common/model/social_login.dart';
import 'package:keyket/common/model/user_model.dart';

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
      String name = user!.kakaoAccount!.profile!.nickname!;

      // Firestore에 사용자 데이터 저장
      await _createUserInFirestore(kakaoId, name);

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

Future<void> _createUserInFirestore(String id, String name) async {
  var counterRef =
      FirebaseFirestore.instance.collection('user_count').doc('userCounter');
  var userRef = FirebaseFirestore.instance.collection('user');

  DocumentSnapshot userSnapshot = await userRef.doc(id).get();

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

      transaction.set(userRef.doc(id),
          {'nickname': name, 'image': '', 'inviteCode': updatedCount});
    }
  });
}
