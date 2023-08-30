import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

void saveToFirestore() async {
  await firestore.collection('notification').add(notificationMap);
}

final Map<String, dynamic> notificationMap = {
  'content': '안녕하세요.\n여행을 여는 열쇠 키킷입니다.\n앱을 출시하여 여러분들을 만나게 되어 정말 기쁩니다.\n감사합니다.',
  'title': '안녕하세요. 키킷입니다!',
  'updatedAt': DateTime(2023, 8, 27, 18, 04),
};
