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

      await createUserInFirestore(userCredential.user!.uid, '일단 이거해');

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
