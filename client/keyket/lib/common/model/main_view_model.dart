import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:keyket/common/model/social_login.dart';

class MainViewModel {
  final SocialLogin _socialLogin;
  bool isLogin = false;
  User? user;

  MainViewModel(this._socialLogin);

  Future login() async {
    isLogin == await _socialLogin.login();
    if (isLogin) {
      user = await UserApi.instance.me();
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    isLogin = false;
    user = null;
  }
}
