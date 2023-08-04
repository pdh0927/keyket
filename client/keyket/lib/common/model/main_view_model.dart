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
        'photoURL': user!.kakaoAccount!.profile!.profileImageUrl
      });
      print(customToken);
      await FirebaseAuth.instance.signInWithCustomToken(customToken);

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
