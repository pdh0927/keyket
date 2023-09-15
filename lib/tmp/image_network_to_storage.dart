import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:keyket/common/component/compress_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:uuid/uuid.dart';

Future<File> downloadImageToFile(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/${Path.basename(imageUrl)}');
  return file.writeAsBytes(response.bodyBytes);
}

Future<void> uploadToFirebase(Map<String, dynamic> data) async {
  // 0. UUID 생성
  var uuid = Uuid();
  String uniqueId = uuid.v1();

  // 1. 이미지 파일로 다운로드
  final File? imageFile = await downloadImageToFile(data['image']);

  // 2. 이미지 압축
  final File? compressedImageFile = await compressImage(imageFile: imageFile);
  if (compressedImageFile == null) return; // 이미지가 없거나 압축 중 문제 발생

  // 3. Firebase Storage에 이미지 업로드
  final storageReference = FirebaseStorage.instance
      .ref()
      .child('images/recommend/$uniqueId.jpg'); // UUID를 사용하여 파일 이름 지정
  final uploadTask = storageReference.putFile(compressedImageFile);
  final snapshot = await uploadTask.whenComplete(() => {});
  final downloadUrl = await snapshot.ref.getDownloadURL();

  // 4. Firestore에 데이터 저장
  final firestoreReference = FirebaseFirestore.instance.collection('recommend');
  await firestoreReference.add({
    'content': data['content'],
    'region': data['region'],
    'theme': data['theme'],
    'image': downloadUrl,
  });
}

Future<void> uploadDatas(List<Map<String, dynamic>> list) async {
  print('total : ${list.length}');
  print('start');

  try {
    for (int i = 0; i < list.length; i++) {
      await uploadToFirebase(list[i]);
      print(i);
    }
  } catch (e) {
    print(e);
  }

  print('end');
}

List<Map<String, dynamic>> list = [
  {
    "content": "김광석 다시 그리기 길에서 커플 자물쇠 걸기 ",
    "region": "daegu",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/84/2556884.jpg"
  },
  {
    "content": "김광석 다시 그리기 길에서 인형사격해서 인형 따기",
    "region": "daegu",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/84/2556884.jpg"
  },
  {
    "content": "김광석 다시 그리기 길에서 기타치는 김광석 동상이랑 사진 찍기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/84/2556884.jpg"
  },
  {
    "content": "동성로에서 예쁜 카페가서 인생샷 찍기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/73/2951473.jpg"
  },
  {
    "content": "서문시장에서 대구의 명물 납작만두 먹기",
    "region": "daegu",
    "theme": ["healing", "food", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/18/2588718.jpg"
  },
  {
    "content": "앞산전망대 올라가서 토끼랑 사진 찍기 ",
    "region": "daegu",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/44/2633144.jpg"
  },
  {
    "content": "앞산전망대 올라가서 사투리퀴즈 100점 받기",
    "region": "daegu",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/44/2633144.jpg"
  },
  {
    "content": "앞산전망대 올라가서 대구의 야경 구경하기",
    "region": "daegu",
    "theme": ["healing", "date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/44/2633144.jpg"
  },
  {
    "content": "두류공원 야외음악당에서 피크닉 하기",
    "region": "daegu",
    "theme": ["healing", "food", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/10/1018010.jpg"
  },
  {
    "content": "동성로 스파크랜드 관람차타면서 대구 시내 한 눈에 내려다보기",
    "region": "daegu",
    "theme": ["healing", "date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/73/2951473.jpg"
  },
  {
    "content": "강정보에서 노을보며 전동바이크 타기",
    "region": "daegu",
    "theme": ["healing", "date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/26/2029226.jpg"
  },
  {
    "content": "서문시장 야시장에서 맛있는 길거리음식 먹기",
    "region": "daegu",
    "theme": ["healing", "food", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/18/2588718.jpg"
  },
  {
    "content": "아쿠아리움에서 나랑 닮은 물고기 찾기",
    "region": "daegu",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/59/2951359.jpg"
  },
  {
    "content": "달성공원에서 귀여운 동물친구들 보면서 산책하기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/83/2442983.jpg"
  },
  {
    "content": "팔공산 갓바위 올라가서 소원빌기",
    "region": "daegu",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/23/2950423.jpg"
  },
  {
    "content": "수성못에서 버스킹 들으면서 따라 부르기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/04/2951604.jpg"
  },
  {
    "content": "수성못에서 오리배 타기",
    "region": "daegu",
    "theme": ["healing", "date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/04/2951604.jpg"
  },
  {
    "content": "수목원에서 맑은 공기 마시며 산책하기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/30/2951930.jpg"
  },
  {
    "content": "팔공산에서 케이블카 타고 산 경치 구경하기",
    "region": "daegu",
    "theme": ["activity", "healing"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/39/2633639.jpg"
  },
  {
    "content": "불로동 고분군에서 고분사이에서 인생샷 찍기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/55/2907655.JPG"
  },
  {
    "content": "치맥 페스티벌에서 맥주 마시며 콘서트 보기",
    "region": "daegu",
    "theme": ["healing", "food", "festival", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/73/2028573.jpg"
  },
  {
    "content": "치맥 페스티벌에서 돗자리 펴고 치맥 먹기",
    "region": "daegu",
    "theme": ["healing", "food", "festival", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/73/2028573.jpg"
  },
  {
    "content": "83타워 아이스 링크장에서 땀 뻘뻘 흘릴 만큼 타보기",
    "region": "daegu",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/86/1017986.jpg"
  },
  {
    "content": "83타워 번지점프에 가서 스릴 넘치는 사진 찍기",
    "region": "daegu",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/86/1017986.jpg"
  },
  {
    "content": "팔공산 동화사에서 템플스테이 해보기",
    "region": "daegu",
    "theme": ["healing", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/92/1948892.jpg"
  },
  {
    "content": "비슬산계곡에서 물놀이하고 닭백숙 먹기",
    "region": "daegu",
    "theme": ["food", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/70/2637870.jpg"
  },
  {
    "content": "비슬산계곡에서 시원한 수박 먹기",
    "region": "daegu",
    "theme": ["food", "healing"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/70/2637870.jpg"
  },
  {
    "content": "비슬산 자연휴양림에서 숲속 캠핑 즐기기",
    "region": "daegu",
    "theme": ["healing", "date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/70/2637870.jpg"
  },
  {
    "content": "다이어트 중 서문시장에 가서 음식 냄새만 맡아보기",
    "region": "daegu",
    "theme": ["activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/18/2588718.jpg"
  },
  {
    "content": "해넘이 전망대에서 커피 마시면서 야경 구경하기",
    "region": "daegu",
    "theme": ["healing", "food", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/99/2951599.jpg"
  },
  {
    "content": "불로동 고분군에서 시내전망을 바라보며 산책하기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/55/2907655.JPG"
  },
  {
    "content": "동성로 스파크랜드 관람차 안에서 노래 100점 맞아보기",
    "region": "daegu",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/73/2951473.jpg"
  },
  {
    "content": "남평문씨본리세거지에서 예쁜 능소화와 함께 인생 사진 남기기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/88/2557888.jpg"
  },
  {
    "content": "서문야시장에 있는 모든 음식 하루 만에 다 먹어보기",
    "region": "daegu",
    "theme": ["food", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/18/2588718.jpg"
  },
  {
    "content": "동촌유원지에서 벚꽃이랑 같이 사진 찍기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/41/2637841.jpg"
  },
  {
    "content": "반야월 연꽃단지에서 연꽃을 바라보며 산책하기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/77/1058177.jpg"
  },
  {
    "content": "안지랑 곱창 골목에서 곱창, 막창 거덜 내기",
    "region": "daegu",
    "theme": ["food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/63/2608563.jpg"
  },
  {
    "content": "스파밸리에서 물놀이 하루 종일 즐기기",
    "region": "daegu",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/38/2951938.jpg"
  },
  {
    "content": "서상돈 고택에서 전통놀이 체해보기",
    "region": "daegu",
    "theme": ["hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/11/2804411.jpg"
  },
  {
    "content": "3.1절에 3.1운동 계단 올라가보기",
    "region": "daegu",
    "theme": ["hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/70/1734470.jpg"
  },
  {
    "content": "이월드 회전목마 앞에서 교복 입고 사진 찍기",
    "region": "daegu",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/71/2951671.jpg"
  },
  {
    "content": "오페라하우스에서 공연 관람하기",
    "region": "daegu",
    "theme": ["healing", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/74/1017974.jpg"
  },
  {
    "content": "근대골목투어 하기",
    "region": "daegu",
    "theme": ["hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/29/2804429.jpg"
  },
  {
    "content": "옥연지 송해공원 돌며 튤립 구경하기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/35/2951935.jpg"
  },
  {
    "content": "사문진 나루터에서 행운의 동전 던지기 해보기",
    "region": "daegu",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/41/2951941.jpg"
  },
  {
    "content": "사문진 나루터에서 유람선 타보기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/41/2951941.jpg"
  },
  {
    "content": "강정보에서 캠프닉 해보기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/29/2951829.jpg"
  },
  {
    "content": "강정보 디아크에서 오리배 타보기",
    "region": "daegu",
    "theme": ["healing", "date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/29/2951829.jpg"
  },
  {
    "content": "이월드에 벚꽃놀이 가기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/71/2951671.jpg"
  },
  {
    "content": "똥집 골목가서 똥집 먹어보기",
    "region": "daegu",
    "theme": ["food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/99/2608699.jpg"
  },
  {
    "content": "마늘 듬뿍 든 동인동 찜갈비 먹어보기",
    "region": "daegu",
    "theme": ["food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/52/2608552.jpg"
  },
  {
    "content": "수성못이 보이는 루프탑에서 인생샷 찍기",
    "region": "daegu",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/04/2951604.jpg"
  },
  {
    "content": "팔공산 등산 후 막걸리 마시기",
    "region": "daegu",
    "theme": ["activity", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/23/2950423.jpg"
  },
  {
    "content": "마비정벽화마을에서 쉽게 찾을 수 없는 옛날 물건 만나보기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/71/2951871.jpg"
  },
  {
    "content": "남평 문씨 본리 세거지에서 고즈넉한 분위기의 돌담길을 따라서 산책여행하기",
    "region": "daegu",
    "theme": ["healing", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/88/2557888.jpg"
  },
  {
    "content": "동화사에서 세계 최대 규모 석조불상인 약사여래대불 보기",
    "region": "daegu",
    "theme": ["hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/92/1948892.jpg"
  },
  {
    "content": "경상감영공원에서 도심 한복판 숲과 정원을 거닐며 역사 공부하기",
    "region": "daegu",
    "theme": ["healing", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/87/1732287.jpg"
  },
  {
    "content": "이국적인 계산성당을 거닐며 고딕 양식의 외관에 매료돼보기",
    "region": "daegu",
    "theme": ["healing", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/26/2951426.jpg"
  },
  {
    "content": "아름드리 은행나무와 아름다운 토담을 품은 도동서원에서 힐링하기",
    "region": "daegu",
    "theme": ["healing", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/28/1948328.jpg"
  },
  {
    "content": "화산산성에서 고랭지 채소로 비빔밥 먹기",
    "region": "daegu",
    "theme": ["food", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/47/2819847.jpg"
  },
  {
    "content": "동화사 세계최대석불앞에서 소원빌기",
    "region": "daegu",
    "theme": ["healing"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/92/1948892.jpg"
  },
  {
    "content": "방짜유기테마파크에서 방짜유기에 대한 역사와 다양한 방짜유기 제품 관람하기",
    "region": "daegu",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/60/1947960.jpg"
  },
  {
    "content": "비슬산참꽃문화재에서 한폭의 수채화같은 참꽃들을 구경하기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/70/2637870.jpg"
  },
  {
    "content": "동성로축제에서 퍼레이드 구경하기",
    "region": "daegu",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/73/2951473.jpg"
  },
  {
    "content": "달구벌관등놀이축제에서 아름다운 관등을 날려보기",
    "region": "daegu",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/11/2555311.jpg"
  },
  {
    "content": "약령시 한방문화축제에서 다양한 한방체험 해보기",
    "region": "daegu",
    "theme": ["festival"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/26/2804426.jpg"
  },
  {
    "content": "해운대 블루라인파크 해변 열차 타면서 경치 구경하기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/59/2952359.jpg"
  },
  {
    "content": "해운대 블루라인파크 스카이 캡슐 안에서 경치 구경하며 사진 찍기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/59/2952359.jpg"
  },
  {
    "content": "영도 흰 여울 문화마을 터널 앞 포토존에서 사진 찍기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/60/2960960.jpg"
  },
  {
    "content": "영도 흰 여울 문화마을 해녀 노상에서 바다 바라보며 회 먹기",
    "region": "busan",
    "theme": ["healing", "food", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/60/2960960.jpg"
  },
  {
    "content": "영도 흰 여울 문화마을에서 남항대교 뷰에서 노을 구경하기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/60/2960960.jpg"
  },
  {
    "content": "해운대 해수욕장에서 버스킹 해보기",
    "region": "busan",
    "theme": ["healing", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/08/2953208.jpg"
  },
  {
    "content": "해운대 해수욕장에서 입술 파랗게 될 때까지 수영해 보기",
    "region": "busan",
    "theme": ["activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/08/2953208.jpg"
  },
  {
    "content": "해운대 해수욕장에서 햇빛 받으면서 태닝하기",
    "region": "busan",
    "theme": ["healing"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/08/2953208.jpg"
  },
  {
    "content": "해운대 동백섬에서 산책하기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/34/2988734.jpg"
  },
  {
    "content": "해운대 전통시장에서 줄 서서 호떡 사먹기",
    "region": "busan",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/05/2928305.jpg"
  },
  {
    "content": "해운대 더베이 101에서 물에 반사되는 사진 찍기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/40/2988740.jpg"
  },
  {
    "content": "해운대 요트 타면서 바다 구경하기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/12/2802912.jpg"
  },
  {
    "content": "기장 해동용궁사에서 바다 보며 소원 빌기",
    "region": "busan",
    "theme": ["healing", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/78/2499978.jpg"
  },
  {
    "content": "겨울에 해운대 해수욕장 입수하기",
    "region": "busan",
    "theme": ["activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/20/1971320.jpg"
  },
  {
    "content": "광안대교를 배경으로 사진 찍기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/59/2928159.jpg"
  },
  {
    "content": "수많은 인파들과 광안리 불꽃축제 즐기기",
    "region": "busan",
    "theme": ["date", "festival"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/59/2928159.jpg"
  },
  {
    "content": "전날 대선 마시고 밀면으로 해장하기",
    "region": "busan",
    "theme": ["food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/75/2928575.jpg"
  },
  {
    "content": "전날 대선 마시고 국밥거리에서 국밥으로 해장하기",
    "region": "busan",
    "theme": ["food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/72/2928572.jpg"
  },
  {
    "content": "감천 문화마을 이장님이 됐다는 느낌으로 한 바퀴 걸어보기",
    "region": "busan",
    "theme": ["healing", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/42/2927842.jpg"
  },
  {
    "content": "석불사 석불암 앞에서 스님의 목탁소리를 들으며 잠시 일상의 걱정거리를 잊어보기",
    "region": "busan",
    "theme": ["healing", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/99/2928799.jpg"
  },
  {
    "content": "영도 등대에서 태종대를 한눈에 담아보기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/62/1932662.jpg"
  },
  {
    "content": "송도 해상 케이블카 타고 바다 위를 날아보기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/69/2984069.jpg"
  },
  {
    "content": "유리 바닥으로 된 송도 구름 산책로에서 마치 바다 위를 걷는다는 느낌 받아보기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/46/2802946.jpg"
  },
  {
    "content": "광안리 해수욕장 모래사장에 하트구멍 만들어서 인싸 사진 찍기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/61/2952361.jpg"
  },
  {
    "content": "해리단길에서 조금은 다른 부산을 느껴보기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/95/2928095.jpg"
  },
  {
    "content": "고요하고 정취 있는 범어사에서 내면을 돌아보고 참된 나를 찾아보기",
    "region": "busan",
    "theme": ["healing", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/77/2927877.jpg"
  },
  {
    "content": "부산근대역사관에서 한 번쯤은 부산의 근현대에 대해 알아보기",
    "region": "busan",
    "theme": ["hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/06/1075106.jpg"
  },
  {
    "content": "보수동 헌책방 골목에서 마음에 드는 책 한권 구입하기",
    "region": "busan",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/53/1075153.jpg"
  },
  {
    "content": "국제시장에서 길거리 음식으로 한끼 떼우기",
    "region": "busan",
    "theme": ["food", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/93/2927993.jpg"
  },
  {
    "content": "동백섬에서 일주 걷기 성공하기",
    "region": "busan",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/34/2988734.jpg"
  },
  {
    "content": "동백 공원에서 만개한 동백꽃으로 인생샷 찍기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/92/992492.jpg"
  },
  {
    "content": "다대포 꿈의 낙조분수 공연 보기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/59/2365659.jpg"
  },
  {
    "content": "부산역이 보이게 인증샷 찍기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/35/2989635.jpg"
  },
  {
    "content": "부산국제영화제에서 레드카펫 위 연예인들 구경하기",
    "region": "busan",
    "theme": ["festival"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/67/2540667.jpg"
  },
  {
    "content": "부산국제영화제에서 다양한 세계영화 구경하기",
    "region": "busan",
    "theme": ["healing", "festival", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/67/2540667.jpg"
  },
  {
    "content": "송도 해상케이블카 타임캡슐에서 추억의 물건 넣기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/69/2984069.jpg"
  },
  {
    "content": "광안리에서 요트타고 불꽃놀이하기",
    "region": "busan",
    "theme": ["healing", "date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/12/2802912.jpg"
  },
  {
    "content": "임시수도기념관에서 6.25전쟁 역사의 한페이지를 바라보기",
    "region": "busan",
    "theme": ["hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/51/2927951.jpg"
  },
  {
    "content": "을숙도 생태공원에서 천연기념물 새들 구경하기",
    "region": "busan",
    "theme": ["healing"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/57/2927657.jpg"
  },
  {
    "content": "누리마루APEC에서 대한민국 정상자리 찾기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/18/1825218.jpg"
  },
  {
    "content": "기장 멸치축제에서 멸치회 먹어보기",
    "region": "busan",
    "theme": ["food", "festival"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/74/1178474.jpg"
  },
  {
    "content": "부산 솔로몬로파크에서 교도소 체험해보기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/95/2928795.jpg"
  },
  {
    "content": "부산전통문화체험관에서 다도체험하면서 차 마시는 예절 배우기",
    "region": "busan",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/70/2928570.jpg"
  },
  {
    "content": "부산해양박물관에서 억울한 가오리 사진찍기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/97/2927497.jpg"
  },
  {
    "content": "아홉산숲 대나무숲에서 판다 찾기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/29/2669629.jpg"
  },
  {
    "content": "광안리해수욕장에서 밤에 웅장한 드론쇼 보기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/59/2928159.jpg"
  },
  {
    "content": "해양자연사자연박물관에서 닥터피쉬로 각질 제거하기",
    "region": "busan",
    "theme": ["healing", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/30/2928430.jpg"
  },
  {
    "content": "해양자연사자연박물관에서 대형고래동상앞에서 사진찍기",
    "region": "busan",
    "theme": ["date", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/30/2928430.jpg"
  },
  {
    "content": "을숙도생태공원에서 자전거빌려서 산책하기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/92/2927792.jpg"
  },
  {
    "content": "용두산공원 꽃시계 앞에서 인증샷 찍기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/44/2927844.jpg"
  },
  {
    "content": "태종대 공원에서 환상적인 해안 절경 감상하기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/41/2953541.jpg"
  },
  {
    "content": "자갈치 시장에서 해물빵 먹어보기",
    "region": "busan",
    "theme": ["food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/83/2927983.jpg"
  },
  {
    "content": "자갈치 시장에서 해산물 이름 맞춰보기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/83/2927983.jpg"
  },
  {
    "content": "청사포 다릿돌 전망대에서 다릿돌 보며 소원 빌기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/12/2537212.jpg"
  },
  {
    "content": "해운대 수목원에서 방목하는 동물 찾아보기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/52/2927352.jpg"
  },
  {
    "content": "씨라이프 아쿠아리움에서 투명보트 타고 상어 먹이주기",
    "region": "busan",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/29/1075829.jpg"
  },
  {
    "content": "영화의 전당에서 무대인사 보기",
    "region": "busan",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/58/2953358.jpg"
  },
  {
    "content": "해리단길에서 숨은 벽화 찾아보기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/95/2928095.jpg"
  },
  {
    "content": "다대포 해수욕장에서 조개와 꽃게 잡아보기",
    "region": "busan",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/42/2927642.jpg"
  },
  {
    "content": "다대포 해수욕장에서 두꺼비집 짓기",
    "region": "busan",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/42/2927642.jpg"
  },
  {
    "content": "부산과학체험관에서 다양한 체험 해보기 ",
    "region": "busan",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/90/2928390.jpg"
  },
  {
    "content": "부산민주공원에서 역사에 대해 알아보기",
    "region": "busan",
    "theme": ["hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/11/2927811.jpg"
  },
  {
    "content": "팥빙수 골목에서 시원한 팥빙수 즐기기",
    "region": "busan",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/88/2826488.jpg"
  },
  {
    "content": "우암동 도시숲 전망대에서 영도 바다와 부산항대교 한눈에 담아보기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/28/2927728.jpg"
  },
  {
    "content": "우암동 도시 달빛 조형물 앞에서 기념샷 찍기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/28/2927728.jpg"
  },
  {
    "content": "40계단문화관에서 역사 전시 관람하기",
    "region": "busan",
    "theme": ["hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/88/2669588.jpg"
  },
  {
    "content": "40계단거리에서 계단가위바위보 하며 오르기",
    "region": "busan",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/88/2669588.jpg"
  },
  {
    "content": "해운대 해수욕장에서 갈매기한테 새우깡 주기",
    "region": "busan",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/20/1971320.jpg"
  },
  {
    "content": "황령산 봉수대에서 야경 보기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/07/2803007.jpg"
  },
  {
    "content": "대변항에서 낚시로 물고기 잡아보기",
    "region": "busan",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/66/2928466.jpg"
  },
  {
    "content": "광안대교를 보며 패들보트타기 ",
    "region": "busan",
    "theme": ["activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/90/2928290.jpg"
  },
  {
    "content": "부산현대미술관에서 다양한 전시 구경하기",
    "region": "busan",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/47/2927647.jpg"
  },
  {
    "content": "복합문화공간 F1963에서 하루 즐기기",
    "region": "busan",
    "theme": ["date", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/81/2928281.jpg"
  },
  {
    "content": "부산커피박물관에서 다양한 원두 구경하고 원하는 원두로 커피 마시기",
    "region": "busan",
    "theme": ["food", "healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/09/2044409.jpg"
  },
  {
    "content": "화명수목원에서 자연의 피톤치드 느끼기",
    "region": "busan",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/01/2928801.jpg"
  },
  {
    "content": "광장시장에서 구제 옷 쇼핑하기",
    "region": "seoul",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/71/2540171.jpg"
  },
  {
    "content": "광장시장에서 먹거리 투어하기",
    "region": "seoul",
    "theme": ["food", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/71/2540171.jpg"
  },
  {
    "content": "별마당 도서관에서 책 읽어보기",
    "region": "seoul",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/26/2733926.jpg"
  },
  {
    "content": "남산타워에서 케이블카 타보기",
    "region": "seoul",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/22/1401622.jpg"
  },
  {
    "content": "남산타워에서 사랑의 자물쇠 걸어보기",
    "region": "seoul",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/67/2519467.jpg"
  },
  {
    "content": "롯데타워 전망대에서 야경 보기",
    "region": "seoul",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/95/2505795.jpg"
  },
  {
    "content": "안국에서 고궁 투어 해보기",
    "region": "seoul",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/07/2029207.jpg"
  },
  {
    "content": "경복궁에서 한복입고 구경하기",
    "region": "seoul",
    "theme": ["date", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/07/2029207.jpg"
  },
  {
    "content": "광화문광장에서 이순신 장군과 세종대왕님에게 인사하기",
    "region": "seoul",
    "theme": ["hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/82/1105582.jpg"
  },
  {
    "content": "통인시장에서 엽전으로 먹거리 사먹기",
    "region": "seoul",
    "theme": ["healing", "food", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/89/2589089.jpg"
  },
  {
    "content": "동대문 DDP에서 모델처럼 옷 입고 사진찍기",
    "region": "seoul",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/51/1961251.jpg"
  },
  {
    "content": "석촌호수 걸으면서 산책하기",
    "region": "seoul",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/10/2907610.jpg"
  },
  {
    "content": "덕수궁 돌담길을 거닐며 사진 찍기",
    "region": "seoul",
    "theme": ["healing", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/20/2504320.jpg"
  },
  {
    "content": "회기역 파전골목에서 비올때 막거리에 파전먹기",
    "region": "seoul",
    "theme": ["healing", "food", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/05/2609605.jpg"
  },
  {
    "content": "연남동 소품샵투어하면서 예쁜 소품 사기",
    "region": "seoul",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/46/2553246.jpg"
  },
  {
    "content": "서울대학교 정문 샤에서 사진찍기",
    "region": "seoul",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/61/1131761.jpg"
  },
  {
    "content": "장충동에서 왕족발 먹기",
    "region": "seoul",
    "theme": ["food", "healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/95/2609595.jpg"
  },
  {
    "content": "신당동에서 즉석떡볶이 먹기",
    "region": "seoul",
    "theme": ["food", "healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/84/2609484.jpg"
  },
  {
    "content": "마장동 축산시장에서 소고기 먹기",
    "region": "seoul",
    "theme": ["food", "healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/88/2609288.jpg"
  },
  {
    "content": "올림픽공원 나홀로 나무에서 인생샷 찍기",
    "region": "seoul",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/70/1833670.jpg"
  },
  {
    "content": "낙산성곽 둘레길 산책하기",
    "region": "seoul",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/30/2504330.jpg"
  },
  {
    "content": "난지 한강공원에서 청춘페스티벌 즐기기",
    "region": "seoul",
    "theme": ["festival", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/38/2658338.jpg"
  },
  {
    "content": "별마당 도서관에서 친구에게 어울릴만한 책 추천해 주기",
    "region": "seoul",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/26/2733926.jpg"
  },
  {
    "content": "서울로 7017에서 서울의 랜드마크를 구경하며 산책하기 ",
    "region": "seoul",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/17/2506117.jpg"
  },
  {
    "content": "서울 불꽃놀이 명당자리에 앉아 불꽃놀이 구경하기",
    "region": "seoul",
    "theme": ["festival", "date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/70/2620370.jpg"
  },
  {
    "content": "봉은사 명상길에서 바람을 느끼며 자연 속에서 생각 정리하기",
    "region": "seoul",
    "theme": ["healing", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/34/2504234.jpg"
  },
  {
    "content": "롯데월드 아이스 링크장에서 스피드 스케이팅 자세하며 달려보기",
    "region": "seoul",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/42/1039042.jpg"
  },
  {
    "content": "하늘공원에서 노을질때 그림같은 사진 찍기",
    "region": "seoul",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/57/1983157.jpg"
  },
  {
    "content": "바쁜 도심 생활은 잠시 잊고 마음 편히 청계천 산책하기",
    "region": "seoul",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/48/2506048.jpg"
  },
  {
    "content": "탑골공원에 가서 대한민국의 자주 독립정신 느껴보기",
    "region": "seoul",
    "theme": ["hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/75/2600975.jpg"
  },
  {
    "content": "인사동에서 전통찻집, 전통공예품 매장 등에 가서 한국의 전통을 느껴보기",
    "region": "seoul",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/38/1143238.jpg"
  },
  {
    "content": "조선시대의 왕이 되었다는 느낌으로 창덕궁 정원 산책하기",
    "region": "seoul",
    "theme": ["healing", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/99/990399.jpg"
  },
  {
    "content": "창덕궁에서 우리나라 전통 문화 체험 해보기",
    "region": "seoul",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/12/990412.jpg"
  },
  {
    "content": "내 옷 중 가장 힙한 옷 입고 홍대에서 놀기",
    "region": "seoul",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/36/950836.jpg"
  },
  {
    "content": "전쟁기념관에서 한국전쟁과 관련된 역사 알아보기",
    "region": "seoul",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/58/2553158.jpg"
  },
  {
    "content": "서울 지하철에서 바쁘게 사는 사람들을 보고 동기부여 받기",
    "region": "seoul",
    "theme": ["healing"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/54/1801054.jpg"
  },
  {
    "content": "여의도 공원에서 인라인스케이트 타기",
    "region": "seoul",
    "theme": ["activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/36/1432436.jpg"
  },
  {
    "content": "여의도 공원 한바퀴 산책하기",
    "region": "seoul",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/36/1432436.jpg"
  },
  {
    "content": "남산골 한옥마을에서 돌쇠 흉내 내보기",
    "region": "seoul",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/01/1004301.jpg"
  },
  {
    "content": "조계사에서 수령이 500년인 백송과 회화나무를 바라보면서 겸손한 마음가짐 갖기",
    "region": "seoul",
    "theme": ["healing", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/35/1854535.jpg"
  },
  {
    "content": "적어도 한국인이라면 국보 1호 숭례문 한번은 가보기",
    "region": "seoul",
    "theme": ["hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/13/2570113.jpg"
  },
  {
    "content": "명동성당에서 천주교회의 훌륭한 건축 양식 엿보기",
    "region": "seoul",
    "theme": ["hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/05/1939005.jpg"
  },
  {
    "content": "창경궁 대온실에서 온실 속 화초들 구경하기",
    "region": "seoul",
    "theme": ["healing", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/11/2973711.JPG"
  },
  {
    "content": "야간개장한 창경궁에서 아름다운 창경궁의 야경 구경하기",
    "region": "seoul",
    "theme": ["date", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/86/2446086.jpg"
  },
  {
    "content": "무지개 해안 도로에서 드라이브하기 ",
    "region": "jeju",
    "theme": ["healing"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/52/2610152.jpg"
  },
  {
    "content": "로컬 흑돼지 맛집 찾아서 먹기",
    "region": "jeju",
    "theme": ["food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/08/2609908.jpg"
  },
  {
    "content": "게스트하우스 파티 가서 친구 사귀기",
    "region": "jeju",
    "theme": ["activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/74/1910574.jpg"
  },
  {
    "content": "돌하르방이랑 똑같은 포즈로 사진 찍기",
    "region": "jeju",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/57/2514457.jpg"
  },
  {
    "content": "제주도 쇠소깍 가서 모르는 사람이랑 카약 경주하기",
    "region": "jeju",
    "theme": ["activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/25/2860225.jpg"
  },
  {
    "content": "이호테우해변에서 바다의 향기를 느끼며 산책하기",
    "region": "jeju",
    "theme": ["healing"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/21/2785421.jpg"
  },
  {
    "content": "함덕해수욕장 모래사장에 하트구멍 만들어서 인싸 사진 찍기",
    "region": "jeju",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/62/2785562.jpg"
  },
  {
    "content": "성산일출봉에서 제주도에서 가장 먼저 뜨는 해 보기",
    "region": "jeju",
    "theme": ["healing", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/97/2990997.jpg"
  },
  {
    "content": "우도의 땅콩은 정말로 더 맛있는지 확인해 보기",
    "region": "jeju",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/45/1940445.jpg"
  },
  {
    "content": "테디베어 뮤지엄 가서 동심으로 돌아가기",
    "region": "jeju",
    "theme": ["healing", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/92/2583692.jpg"
  },
  {
    "content": "섭지코지에서 인생샷 건져서 카톡 프사하기",
    "region": "jeju",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/88/2728188.jpg"
  },
  {
    "content": "협재 해수욕장에서 비키니 입고 수영하기",
    "region": "jeju",
    "theme": ["activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/75/1961475.jpg"
  },
  {
    "content": "자연이 만든 예술작품 주상절리대 감상하기",
    "region": "jeju",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/57/2029257.jpg"
  },
  {
    "content": "비 오는 날 엉또폭포에서 거대한 폭포 보기",
    "region": "jeju",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/20/1318520.jpg"
  },
  {
    "content": "오설록 티 뮤지엄에서 녹차밭 구경하기",
    "region": "jeju",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/26/2027526.jpg"
  },
  {
    "content": "오설록 티 뮤지엄에서 녹차 디저트 먹어보기",
    "region": "jeju",
    "theme": ["food", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/58/1945158.jpg"
  },
  {
    "content": "섭지코지 그랜드 스윙 포토존에서 사진 찍기",
    "region": "jeju",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/88/2728188.jpg"
  },
  {
    "content": "자전거 해안 도로에서 전동 바이크 타기",
    "region": "jeju",
    "theme": ["healing", "date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/67/2390967.jpg"
  },
  {
    "content": "제주 올레길 모든 코스 완주하기",
    "region": "jeju",
    "theme": ["activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/54/2027554.jpg"
  },
  {
    "content": "한라산 등반하기",
    "region": "jeju",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/00/2504300.jpg"
  },
  {
    "content": "한라산 정상에서 한라산 술들고 기념사진 찍기",
    "region": "jeju",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/00/2504300.jpg"
  },
  {
    "content": "눈 쌓인 곳에서 썰매 타보기",
    "region": "jeju",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/33/2762133.jpg"
  },
  {
    "content": "일몰시간에 이호테우해변에서 사진 찍기",
    "region": "jeju",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/21/2785421.jpg"
  },
  {
    "content": "애월 한담 해안 산책로에서 곽지리 해변까지 산책로를 따라 산책하기",
    "region": "jeju",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/62/2728262.jpg"
  },
  {
    "content": "제주 양떼 목장에서 귀여운 양들에게 먹이주기",
    "region": "jeju",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/40/2575940.jpg"
  },
  {
    "content": "제주 양떼 목장에서 양들과 함께 셀카 찍기",
    "region": "jeju",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/40/2575940.jpg"
  },
  {
    "content": "제주 양떼 목장에 늑대 옷 입고 가보기",
    "region": "jeju",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/40/2575940.jpg"
  },
  {
    "content": "구엄리 돌염전에서 인근 바위에 앉아 일몰 구경하기",
    "region": "jeju",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/52/2909352.jpg"
  },
  {
    "content": "이호테우해변에서 목마 등대 포토존 앞에서 인증샷 찍기",
    "region": "jeju",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/21/2785421.jpg"
  },
  {
    "content": "금오름에 올라가서 제주 시내와  바다까지 한눈에 구경하기",
    "region": "jeju",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/43/2703943.jpg"
  },
  {
    "content": "비 온 다음 날 금오름에 올라가 분화구에 물이 고인 모습 보기",
    "region": "jeju",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/43/2703943.jpg"
  },
  {
    "content": "정방폭포에서 폭포와 함께 무지개 사진 찍어보기",
    "region": "jeju",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/48/1806248.jpg"
  },
  {
    "content": "제주민속촌 무더위를 날릴 공포체험 해보기",
    "region": "jeju",
    "theme": ["date", "activity", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/27/1321627.jpg"
  },
  {
    "content": "아쿠아플라넷에서 스쿠버 다이빙하며 물고기와 아이컨택 해보기",
    "region": "jeju",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/92/2587392.jpg"
  },
  {
    "content": "해녀체험하면서 물속에서 문어 들고 사진 찍어보기",
    "region": "jeju",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/95/2541595.jpg"
  },
  {
    "content": "용머리해안에서 화산층을 배경으로 사진 찍기",
    "region": "jeju",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/63/2602063.jpg"
  },
  {
    "content": "아쿠아플라넷 제주에서 돌고래쇼 구경하기",
    "region": "jeju",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/92/2587392.jpg"
  },
  {
    "content": "아쿠아플라넷 제주에서 나와 닮은 해양생물 찾기",
    "region": "jeju",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/92/2587392.jpg"
  },
  {
    "content": "미로공원에서 빠른시간안에 미로 탈출하기",
    "region": "jeju",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/16/2504316.jpg"
  },
  {
    "content": "도깨비도로에서 착시현상 느끼기",
    "region": "jeju",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/02/2009602.jpg"
  },
  {
    "content": "감귤체험 농장에서 감귤따서 맛있게 먹기",
    "region": "jeju",
    "theme": ["food", "date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/12/2704212.jpg\n"
  },
  {
    "content": "잠수함타고 바닷속의 물고기들 구경하기",
    "region": "jeju",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/12/2003312.jpg"
  },
  {
    "content": "아부오름 올라가면서 옆사람에게 아부하기",
    "region": "jeju",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/08/2647808.jpg"
  },
  {
    "content": "승마체험장에서 말타면서 '이랴'하기",
    "region": "jeju",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/20/2496920.jpg"
  },
  {
    "content": "올레시장에서 유명한 오메기떡 사먹기",
    "region": "jeju",
    "theme": ["food", "healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/26/1940426.jpg"
  },
  {
    "content": "배낚시하면서 잡은 해산물로 해물라면 만들어먹기",
    "region": "jeju",
    "theme": ["food", "healing", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/62/1841262.jpg"
  },
  {
    "content": "휴애리 수국축제에서 수국 사이에서 인생샷 찍기",
    "region": "jeju",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/05/2761005.jpg"
  },
  {
    "content": "제주별빛누리공원에서 천체망원경으로 내 별자리 보기",
    "region": "jeju",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/28/1939428.jpg"
  },
  {
    "content": "초콜릿박물관에서 초콜릿만들기 체험하고 맛있게 먹기",
    "region": "jeju",
    "theme": ["food", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/51/1938251.jpg"
  },
  {
    "content": "구룡포근대문화거리에서 일본 가옥들 구경하고 일본 온 척 사진찍기",
    "region": "pohang",
    "theme": ["date", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/53/2644153.jpg"
  },
  {
    "content": "구룡포근대문화거리 드라마 '동백꽃필무렵' 촬영장소에서 주인공처럼 사진찍기",
    "region": "pohang",
    "theme": ["date", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/53/2644153.jpg"
  },
  {
    "content": "구룡포근대문화거리 추억의 느린 우체통에 미래의 나에게 편지쓰기",
    "region": "pohang",
    "theme": ["healing"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/53/2644153.jpg"
  },
  {
    "content": "연오랑 세오녀 테마공원에서 쌍거북바위 구경하기",
    "region": "pohang",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/37/2649437.jpg"
  },
  {
    "content": "연오랑 세오녀 테마공원에서 바다 구경하면서 산책하기",
    "region": "pohang",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/37/2649437.jpg"
  },
  {
    "content": "죽도시장에서 대게 흥정해서 싸게 먹기",
    "region": "pohang",
    "theme": ["food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/79/2649479.jpg"
  },
  {
    "content": "스페이스워크 가장 높은곳까지 올라가서 인증샷 찍기",
    "region": "pohang",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/08/2909208.jpg"
  },
  {
    "content": "보경사 5층 석탑 구경하기",
    "region": "pohang",
    "theme": ["date", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/49/2453849.jpg"
  },
  {
    "content": "이가리닻전망대에서 바다 구경하기",
    "region": "pohang",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/84/2950184.jpg"
  },
  {
    "content": "이가리닻전망대 동굴 포토존에서 사진찍기",
    "region": "pohang",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/84/2950184.jpg"
  },
  {
    "content": "사방기념공원 돌탑에 돌쌓기",
    "region": "pohang",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/49/2989349.jpg"
  },
  {
    "content": "사방기념공원 드라마 '갯마을차차차'에 나온 배 위에서 사진 찍기",
    "region": "pohang",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/49/2989349.jpg"
  },
  {
    "content": "포항운하에서 유람선타면서 갈매기에게 새우깡주기",
    "region": "pohang",
    "theme": ["healing", "date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/71/2909171.jpg"
  },
  {
    "content": "포항운하에서 유람선 기다리면서 트릭아트 사진 찍기",
    "region": "pohang",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/71/2909171.jpg"
  },
  {
    "content": "청하 5일장에서 호떡먹기",
    "region": "pohang",
    "theme": ["food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/26/2707226.jpg"
  },
  {
    "content": "포항 영일대 해수욕장에서 모래성 만들기",
    "region": "pohang",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/76/2939076.jpg"
  },
  {
    "content": "영일대 위에 올라가서 바다 구경하기",
    "region": "pohang",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/35/2504335.jpg"
  },
  {
    "content": "보릿돌교 중앙에서 인생샷 찍기",
    "region": "pohang",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/63/2939063.jpg"
  },
  {
    "content": "호미곶해맞이광장 해바라기밭에서  인생샷 찍기",
    "region": "pohang",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/60/2950160.jpg"
  },
  {
    "content": "요트타고 포항의 야경들을 바라보며 불꽃놀이하기",
    "region": "pohang",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/35/2504335.jpg"
  },
  {
    "content": "국제불빛축제에서 엄청난 불꽃놀이 구경하기",
    "region": "pohang",
    "theme": ["date", "festival"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/23/2504223.jpg"
  },
  {
    "content": "첨성대에서 손바닥위에 첨성대 올리고 사진 찍기",
    "region": "gyeongju",
    "theme": ["date", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/30/2761730.jpg"
  },
  {
    "content": "동궁과 월지에서 아름다운 야경을 배경으로 구경하면서 사진찍기",
    "region": "gyeongju",
    "theme": ["date", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/41/2620341.jpg"
  },
  {
    "content": "대릉원에서 왕릉 사이에서 인생샷 찍기",
    "region": "gyeongju",
    "theme": ["date", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/62/2563762.jpg"
  },
  {
    "content": "국립경주박물관가서 신라시대의 유물 감상하기",
    "region": "gyeongju",
    "theme": ["hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/99/978299.jpg"
  },
  {
    "content": "경주월드가서 제일 무서운 드라켄 타보기",
    "region": "gyeongju",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/99/2585699.jpg"
  },
  {
    "content": "캘리포니아비치가서 튜브에 몸을 맡기고 유수풀 즐기기",
    "region": "gyeongju",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/99/2585699.jpg"
  },
  {
    "content": "월정교에서 아름다운 야경 즐기기",
    "region": "gyeongju",
    "theme": ["healing", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/58/2563758.jpg"
  },
  {
    "content": "실내 식물원 동궁원에서 신기한 식물들 구경하",
    "region": "gyeongju",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/08/1908308.jpg"
  },
  {
    "content": "순두부골목에서 맛있는 순두부찌개 먹기",
    "region": "gyeongju",
    "theme": ["food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/18/1988918.jpg"
  },
  {
    "content": "버드파크에서 앵무새와 대화하고 먹이주기",
    "region": "gyeongju",
    "theme": ["date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/88/1907988.jpg"
  },
  {
    "content": "보문관광단지에서 백조보트 타기",
    "region": "gyeongju",
    "theme": ["healing", "date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/68/2989268.jpg"
  },
  {
    "content": "황리단길에서 황리단길의 명물 십원빵 먹기",
    "region": "gyeongju",
    "theme": ["food", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/80/2989280.jpg"
  },
  {
    "content": "황리단길에서 황리단길의 명물 쫀디기 먹기",
    "region": "gyeongju",
    "theme": ["food", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/80/2989280.jpg"
  },
  {
    "content": "황룡사 역사문화관에서 황룡사9층 목탑 모형보며 신라시대의 위대함 느끼기",
    "region": "gyeongju",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/49/2907749.jpg"
  },
  {
    "content": "교촌마을에서 교촌치킨 시켜서 먹기",
    "region": "gyeongju",
    "theme": ["food", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/70/2595970.jpg"
  },
  {
    "content": "교촌마을에서 한옥들과 돌담길들을 보며 산책하기",
    "region": "gyeongju",
    "theme": ["hist", "healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/70/2595970.jpg"
  },
  {
    "content": "우리나라를 대표하는 불교사찰 불국사에서 석가탑과 다보탑 보기",
    "region": "gyeongju",
    "theme": ["hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/78/2620378.jpg"
  },
  {
    "content": "불국사에서 템플스테이하며 마음을 다스리기",
    "region": "gyeongju",
    "theme": ["healing", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/78/2620378.jpg"
  },
  {
    "content": "황리단길에서 한복입고 돌아다니기",
    "region": "gyeongju",
    "theme": ["date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/68/2989268.jpg"
  },
  {
    "content": "황룡원 중도타워를 배경으로해서 인생샷 찍기 ",
    "region": "gyeongju",
    "theme": ["date", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/49/2907749.jpg"
  },
  {
    "content": "황성공원 꽃밭에서 꽃받침하고 사진찍기",
    "region": "gyeongju",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/93/2760993.jpg"
  },
  {
    "content": "황성공원에서 푸릇푸릇한 식물들 보면서 산책하기",
    "region": "gyeongju",
    "theme": ["healing", "date"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/93/2760993.jpg"
  },
  {
    "content": "경주엑스포대공원에서 신라시대 미디어아트 구경하기",
    "region": "gyeongju",
    "theme": ["date", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/85/2585685.jpg"
  },
  {
    "content": "경주엑스포대공원에서 웅장한 경주타워 밑으로 지나가면서 위에 사진찍기",
    "region": "gyeongju",
    "theme": ["date", "hist"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/85/2585685.jpg"
  },
  {
    "content": "경주엑스포대공원 경주타워 전망대에서 경주를 한눈에 내려다 보기",
    "region": "gyeongju",
    "theme": ["healing", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/85/2585685.jpg"
  },
  {
    "content": "보문정에서 연못을 가득채운 연꽃들을 배경으로 인생샷 찍기",
    "region": "gyeongju",
    "theme": ["healing", "date", "food"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/29/2761529.jpg"
  },
  {
    "content": "보문단지에서 스쿠터빌려서 경주를 둘러보기",
    "region": "gyeongju",
    "theme": ["date", "activity"],
    "image": "http://tong.visitkorea.or.kr/cms2/website/10/2545710.jpg"
  }
];
