import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

void saveToFirestore() async {
  await firestore.collection('notification').add(notificationMap);
}

final Map<String, dynamic> notificationMap = {
  'title': '[공지] 키킷 서비스 변경사항 안내',
  'content':
      '안녕하세요, 키킷입니다.\n키킷 서비스 내 일부 변경사항이 있어 안내드립니다.\n\n■ 변경내용\n 1. recommend 추천 목록 list 이미지 추가\n- 텍스트만 있었던 기존 추천 목록에 이미지를 추가하여 사용자에게 정보를 눈에 띄게 표현하며,\n각 항목에 대한 더 빠른 이해와 식별할 수 있도록 서비스를 수정하였습니다.\n\n2. 홈 화면 수정\n- 홈 화면에 크게 표시되던 버킷리스트를 삭제하고 하단에 바로가기 형태로 수정하였으며, 여러 지역에서 유명한 장소 또는 음식의 사진을 통해 사용자에게 추천하도록 하여 사용자가 홈 화면에서 버킷리스트에 빠르게 접근하고, 지역 관련 정보와 명소를 시각적으로 확인할 수 있게 서비스를 수정하였습니다.\n\n■ 적용일정 및 버전\n- 2023년 9월 12일 (화)\n- Android : ver. 000 이상\n- iOS : ver 11.0 이상\n\n편리하고 유용한 키킷이 되기 위해 앞으로도 노력하겠습니다.\n\n감사합니다.',
  'updatedAt': DateTime(2023, 9, 12, 18, 00),
  'image':
      'https://firebasestorage.googleapis.com/v0/b/keyket-bc537.appspot.com/o/images%2Fbucket%2F393af7b5-68e4-4a42-afdd-0a6f5c04e56d?alt=media&token=3e0088fc-5cda-4391-9e85-2db578839e59',
};
