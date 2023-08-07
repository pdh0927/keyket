import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myInformationProvider =
    StateNotifierProvider<MyInformationNotifer, User?>((ref) {
  return MyInformationNotifer();
});

class MyInformationNotifer extends StateNotifier<User?> {
  MyInformationNotifer() : super(null) {
    getMyInformation();
  }

  Future getMyInformation() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      state = user;
    }
    print(user);
  }
}
