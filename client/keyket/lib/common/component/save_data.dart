import 'package:cloud_firestore/cloud_firestore.dart';

saveData() async {
  List<Map<String, dynamic>> notifications = [
    {
      "content": "김광석 다시 그리기 길에서 커플 자물쇠 걸기 ",
      "region": "daegu",
      "theme": ["date"]
    },
    {
      "content": "김광석 다시 그리기 길에서 인형사격해서 인형 따기",
      "region": "daegu",
      "theme": ["activity", "date"]
    },
    {
      "content": "김광석 다시 그리기 길에서 기타치는 김광석 동상이랑 사진 찍기",
      "region": "daegu",
      "theme": ["healing", "date"]
    },
    {
      "content": "동성로에서 예쁜 카페가서 인생샷 찍기",
      "region": "daegu",
      "theme": ["healing", "date"]
    },
    {
      "content": "서문시장에서 대구의 명물 납작만두 먹기",
      "region": "daegu",
      "theme": ["food", "date", "healing"]
    },
    {
      "content": "앞산전망대 올라가서 토끼랑 사진 찍기 ",
      "region": "daegu",
      "theme": ["activity", "date"]
    },
    {
      "content": "앞산전망대 올라가서 사투리퀴즈 100점 받기",
      "region": "daegu",
      "theme": ["activity", "date"]
    },
    {
      "content": "앞산전망대 올라가서 대구의 야경 구경하기",
      "region": "daegu",
      "theme": ["activity", "healing", "date"]
    },
    {
      "content": "두류공원 야외음악당에서 피크닉 하기",
      "region": "daegu",
      "theme": ["healing", "date", "food"]
    },
    {
      "content": "동성로 스파크랜드 관람차타면서 대구 시내 한 눈에 내려다보기",
      "region": "daegu",
      "theme": ["healing", "activity", "date"]
    },
    {
      "content": "강정보에서 노을보며 전동바이크 타기",
      "region": "daegu",
      "theme": ["healing", "activity", "date"]
    },
    {
      "content": "서문시장 야시장에서 맛있는 길거리음식 먹기",
      "region": "daegu",
      "theme": ["food", "date", "healing"]
    },
    {
      "content": "칠성야시장에서 신천을 바라보며 맛있는 음식 먹기",
      "region": "daegu",
      "theme": ["food", "date", "healing"]
    },
    {
      "content": "아쿠아리움에서 나랑 닮은 물고기 찾기",
      "region": "daegu",
      "theme": ["date"]
    },
    {
      "content": "라이온즈 파크에서 치킨먹으면서 야구 응원하기",
      "region": "daegu",
      "theme": ["date", "food", "activity"]
    },
    {
      "content": "DGB대구은행파크에서 맛있는거 먹으면서 축구 응원하기",
      "region": "daegu",
      "theme": ["activity", "date", "food"]
    },
    {
      "content": "달성공원에서 귀여운 동물친구들 보면서 산책하기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "팔공산 갓바위 올라가서 소원빌기",
      "region": "daegu",
      "theme": ["date", "activity"]
    },
    {
      "content": "수성못에서 버스킹 들으면서 따라 부르기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "동성로에서 버스킹 들으면서 따라 부르기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "수성못에서 오리배 타기",
      "region": "daegu",
      "theme": ["date", "healing", "activity"]
    },
    {
      "content": "동촌유원지에서 오리배 타면서 하체 운동하기",
      "region": "daegu",
      "theme": ["date", "healing", "activity"]
    },
    {
      "content": "동촌유원지에서  피크닉 하기",
      "region": "daegu",
      "theme": ["date", "food", "healing"]
    },
    {
      "content": "하중도 유채꽃밭에서 꽃 귀에 걸고 사진 찍기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "수목원에서 맑은 공기 마시며 산책하기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "팔공산에서 케이블카 타고 산 경치 구경하기",
      "region": "daegu",
      "theme": ["activity", "healing"]
    },
    {
      "content": "봉무공원에서 수상레포츠 즐기기",
      "region": "daegu",
      "theme": ["activity"]
    },
    {
      "content": "이곡장미공원에서 장미와 함께 인생샷 찍기",
      "region": "daegu",
      "theme": ["healing", "date"]
    },
    {
      "content": "불로동 고분군에서 고분사이에서 인생샷 찍기",
      "region": "daegu",
      "theme": ["healing", "date"]
    },
    {
      "content": "수성못 페스티벌에서 공연 즐기기",
      "region": "daegu",
      "theme": ["date", "festival"]
    },
    {
      "content": "수성못 페스티벌에서 대구 대표 먹거리 다 먹어보기",
      "region": "daegu",
      "theme": ["date", "festival", "food"]
    },
    {
      "content": "수성못 페스티벌에서 전시 관람하기",
      "region": "daegu",
      "theme": ["healing", "date", "festival", "hist"]
    },
    {
      "content": "치맥 페스티벌에서 맥주 마시며 콘서트 보기",
      "region": "daegu",
      "theme": ["healing", "date", "festival", "food"]
    },
    {
      "content": "치맥 페스티벌에서 돗자리 펴고 치맥 먹기",
      "region": "daegu",
      "theme": ["healing", "date", "festival", "food"]
    },
    {
      "content": "육신사 배롱나무 앞에서 사진 찍기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "논공 꽃단지 해바라기 꽃밭에서 사진 찍기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "국제 사격장에서 정중앙 맞추기",
      "region": "daegu",
      "theme": ["date", "activity"]
    },
    {
      "content": "대구미술관에서 전시 관람하기",
      "region": "daegu",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "칠성 꽃 시장에서 나와 닮은 꽃 찾아보기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "83타워 아이스 링크장에서 땀 뻘뻘 흘릴 만큼 타보기",
      "region": "daegu",
      "theme": ["date", "activity"]
    },
    {
      "content": "83타워 번지점프에 가서 스릴 넘치는 사진 찍기",
      "region": "daegu",
      "theme": ["date", "activity"]
    },
    {
      "content": "네이처파크에서 동물들에게 먹이주기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "네이처파크에서 낭만적인 카약 타기",
      "region": "daegu",
      "theme": ["date", "healing", "activity"]
    },
    {
      "content": "83타워에서 스릴 있는 번지점프하기",
      "region": "daegu",
      "theme": ["date", "activity"]
    },
    {
      "content": "맥주축제에서 맥주 3초 만에 마셔보기",
      "region": "daegu",
      "theme": ["activity", "food"]
    },
    {
      "content": "팔공산 동화사에서 템플스테이 해보기",
      "region": "daegu",
      "theme": ["date", "healing", "hist"]
    },
    {
      "content": "도림사 템플스테이에서 경치 보며 힐링하기",
      "region": "daegu",
      "theme": ["date", "healing", "hist"]
    },
    {
      "content": "대표 도시숲에서 야경 보며 산책하기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "비슬산계곡에서 물놀이하고 닭백숙 먹기",
      "region": "daegu",
      "theme": ["food", "activity"]
    },
    {
      "content": "비슬산계곡에서 시원한 수박 먹기",
      "region": "daegu",
      "theme": ["food", "healing"]
    },
    {
      "content": "비슬산 자연휴양림에서 숲속 캠핑 즐기기",
      "region": "daegu",
      "theme": ["date", "healing", "activity"]
    },
    {
      "content": "다이어트 중 서문시장에 가서 음식 냄새만 맡아보기",
      "region": "daegu",
      "theme": ["activity"]
    },
    {
      "content": "해넘이 전망대에서 커피 마시면서 야경 구경하기",
      "region": "daegu",
      "theme": ["date", "food", "healing"]
    },
    {
      "content": "불로동 고분군에서 시내전망을 바라보며 산책하기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "유명한 푸딩 빙수 웨이팅 없이 먹어보기",
      "region": "daegu",
      "theme": ["date", "food"]
    },
    {
      "content": "동성로 스파크랜드 관람차 안에서 노래 100점 맞아보기",
      "region": "daegu",
      "theme": ["date", "activity"]
    },
    {
      "content": "남평문씨본리세거지에서 예쁜 능소화와 함께 인생 사진 남기기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "서문야시장에 있는 모든 음식 하루 만에 다 먹어보기",
      "region": "daegu",
      "theme": ["date", "food"]
    },
    {
      "content": "동촌유원지에서 벚꽃이랑 같이 사진 찍기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "반야월 연꽃단지에서 연꽃을 바라보며 산책하기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "안지랑 곱창 골목에서 곱창,막창 거덜 내기",
      "region": "daegu",
      "theme": ["food"]
    },
    {
      "content": "뭉티기 접시 뒤집어서 안 떨어지는지 확인해 보기",
      "region": "daegu",
      "theme": ["food"]
    },
    {
      "content": "해맞이공원에서 산책하며 금계국 구경하기",
      "region": "daegu",
      "theme": ["healing", "date"]
    },
    {
      "content": "해맞이공원 이팝나무 포토존에서 전신샷 찍기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "희움 일본군 위안부 역사관에서 역사 알아보기",
      "region": "daegu",
      "theme": ["hist"]
    },
    {
      "content": "스파밸리에서 물놀이 하루 종일 즐기기",
      "region": "daegu",
      "theme": ["activity", "date"]
    },
    {
      "content": "비 오는 날 크레이지 팡팡에서 실내 액티비티 즐기",
      "region": "daegu",
      "theme": ["activity", "date"]
    },
    {
      "content": "달성노을공원에서 노을 보며 차박하기",
      "region": "daegu",
      "theme": ["healing", "date"]
    },
    {
      "content": "서상돈 고택에서 전통놀이 체해보기",
      "region": "daegu",
      "theme": ["hist"]
    },
    {
      "content": "3.1절에 3.1운동 계단 올라가보기",
      "region": "daegu",
      "theme": ["hist"]
    },
    {
      "content": "벚꽃 핀 날 침산공원 계단 포토존에서 사진 찍기",
      "region": "daegu",
      "theme": ["healing", "date"]
    },
    {
      "content": "향촌문화관에서 대구의 옛 모습 구경하기",
      "region": "daegu",
      "theme": ["hist"]
    },
    {
      "content": "이월드 회전목마 앞에서 교복 입고 사진 찍기",
      "region": "daegu",
      "theme": ["date"]
    },
    {
      "content": "시티투어버스 타고 대구 투어하기",
      "region": "daegu",
      "theme": ["date"]
    },
    {
      "content": "오페라하우스에서 공연 관람하기",
      "region": "daegu",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "근대골목투어 하기",
      "region": "daegu",
      "theme": ["hist"]
    },
    {
      "content": "아이니테마파크에서 백사자 구경하기",
      "region": "daegu",
      "theme": ["date"]
    },
    {
      "content": "옥연지 송해공원 돌며 튤립 구경하기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "사문진 나루터에서 행운의 동전 던지기 해보기",
      "region": "daegu",
      "theme": ["date"]
    },
    {
      "content": "사문진 나루터에서 유람선 타보기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "강정보에서 캠프닉 해보기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "강정보 디아크에서 오리배 타보기",
      "region": "daegu",
      "theme": ["date", "healing", "activity"]
    },
    {
      "content": "고산골 공룡 공원에서 생동감 넘치는 공룡 구경하기",
      "region": "daegu",
      "theme": ["date"]
    },
    {
      "content": "삼국유사 테마파크에서 튜브슬라이드 타보기",
      "region": "daegu",
      "theme": ["date", "hist"]
    },
    {
      "content": "삼국유사 테마파크 가온누리관에서 역사 알아보기",
      "region": "daegu",
      "theme": ["date", "hist"]
    },
    {
      "content": "봉무공원 곤충생태관에서 곤충 이름 맞춰보기",
      "region": "daegu",
      "theme": ["date", "hist"]
    },
    {
      "content": "봉무공원 나비생태관에서 나비 구경하기",
      "region": "daegu",
      "theme": ["date"]
    },
    {
      "content": "토이빌리지에서 물범 먹이주기",
      "region": "daegu",
      "theme": ["date"]
    },
    {
      "content": "대구교육박물관에서 국민학교 체험하기",
      "region": "daegu",
      "theme": ["hist", "date"]
    },
    {
      "content": "이월드에 벚꽃놀이 가기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "동성로 길거리 음식 다 먹어보기",
      "region": "daegu",
      "theme": ["food", "date"]
    },
    {
      "content": "똥집 골목가서 똥집 먹어보기",
      "region": "daegu",
      "theme": ["food"]
    },
    {
      "content": "마늘 듬뿍 든 동인동 찜갈비 먹어보기",
      "region": "daegu",
      "theme": ["food"]
    },
    {
      "content": "북성로 연탄 불고기에 맛있는참 한잔하기",
      "region": "daegu",
      "theme": ["food", "date"]
    },
    {
      "content": "교동 인스타 핫플레이스 술집 가보기",
      "region": "daegu",
      "theme": ["food", "date"]
    },
    {
      "content": "교동 인스타 핫플레이스 카페 가보기",
      "region": "daegu",
      "theme": ["food", "date"]
    },
    {
      "content": "우리나라에서 가장 큰 신세계 백화점 가서 하루 놀기",
      "region": "daegu",
      "theme": ["date"]
    },
    {
      "content": "수성못이 보이는 루프탑에서 인생샷 찍기",
      "region": "daegu",
      "theme": ["date"]
    },
    {
      "content": "팔공산 등산 후 막걸리 마시기",
      "region": "daegu",
      "theme": ["activity", "food"]
    },
    {
      "content": "마비정벽화마을에서 쉽게 찾을 수 없는 옛날 물건 만나보기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "남평 문씨 본리 세거지에서 고즈넉한 분위기의 돌담길을 따라서 산책여행하기",
      "region": "daegu",
      "theme": ["date", "healing", "hist"]
    },
    {
      "content": "크리스마스에 동성로에서 거대한 트리 앞에서 사진 찍기",
      "region": "daegu",
      "theme": ["date"]
    },
    {
      "content": "동화사에서 세계 최대 규모 석조불상인 약사여래대불 보기",
      "region": "daegu",
      "theme": ["hist"]
    },
    {
      "content": "경상감영공원에서 도심 한복판 숲과 정원을 거닐며 역사 공부하기",
      "region": "daegu",
      "theme": ["hist", "healing", "date"]
    },
    {
      "content": "이국적인 계산성당을 거닐며 고딕 양식의 외관에 매료돼보기",
      "region": "daegu",
      "theme": ["hist", "healing"]
    },
    {
      "content": "아름드리 은행나무와 아름다운 토담을 품은 도동서원에서 힐링하기",
      "region": "daegu",
      "theme": ["hist", "healing"]
    },
    {
      "content": "국채보상운동 기념공원에서 애국심 느껴보기",
      "region": "daegu",
      "theme": ["hist"]
    },
    {
      "content": "커피 한잔 들고 국채보상운동 기념공원에서 여유 즐기기",
      "region": "daegu",
      "theme": ["hist", "healing"]
    },
    {
      "content": "장곡자연휴양림에서 삼림욕과 생태체험 해보기",
      "region": "daegu",
      "theme": ["healing"]
    },
    {
      "content": "화산산성에서 고랭지 채소로 비빔밥 먹기",
      "region": "daegu",
      "theme": ["food", "hist"]
    },
    {
      "content": "삼국유사테마파크에서 여러 콘텐츠로 삼국유사 알아보기",
      "region": "daegu",
      "theme": ["hist"]
    },
    {
      "content": "침산공원 가볍게 조깅하기",
      "region": "daegu",
      "theme": ["activity"]
    },
    {
      "content": "자전거 도로에서 신천을 보며 자전거 타기",
      "region": "daegu",
      "theme": ["activity"]
    },
    {
      "content": "대구시민안전테마파크에서 중요한 안전에 관련된 정보 배우기",
      "region": "daegu",
      "theme": ["date", "activity"]
    },
    {
      "content": "동화사 세계최대석불앞에서 소원빌기",
      "region": "daegu",
      "theme": ["healing"]
    },
    {
      "content": "방짜유기테마파크에서 방짜유기에 대한 역사와 다양한 방짜유기 제품 관람하기",
      "region": "daegu",
      "theme": ["date"]
    },
    {
      "content": "비슬산참꽃문화재에서 한폭의 수채화같은 참꽃들을 구경하기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "동성로축제에서 퍼레이드 구경하기",
      "region": "daegu",
      "theme": ["date", "activity"]
    },
    {
      "content": "달구벌관등놀이축제에서 아름다운 관등을 날려보기",
      "region": "daegu",
      "theme": ["date", "healing"]
    },
    {
      "content": "대구국제뮤지컬페스티벌에서 뮤지컬 관람하기",
      "region": "daegu",
      "theme": ["hist", "date", "festival"]
    },
    {
      "content": "파워풀대구페스티벌에서 다채로운 공연예술 퍼레이드 구경하기",
      "region": "daegu",
      "theme": ["festival", "healing", "date"]
    },
    {
      "content": "달성 100대 피아노축제에서 100대의 피아노가 들려주는 아름다운 피아노소리 감상하기",
      "region": "daegu",
      "theme": ["festival", "date"]
    },
    {
      "content": "달성 대구현대미술제에서 젊은작가들의 다양한 현대미술작품 감상하기",
      "region": "daegu",
      "theme": ["festival"]
    },
    {
      "content": "대명공연거리 로드페스티벌에서 다양한 문화공연 관람하기",
      "region": "daegu",
      "theme": ["festival"]
    },
    {
      "content": "약령시 한방문화축제에서 다양한 한방체험 해보기",
      "region": "daegu",
      "theme": ["festival"]
    },
    {
      "content": "경삼감영풍속재연축제에서 전통풍속을 감상하고 역사의식 고취하기",
      "region": "daegu",
      "theme": ["festival"]
    },
    {
      "content": "달성토성마을골목축제에서 달성토성의 역사적 문화적 가치 재조명하며 아름다운 마을 구경하기",
      "region": "daegu",
      "theme": ["festival"]
    },
    {
      "content": "장미꽃필무렵 축제에서 장미를 활용한 다양한 체험활동 해보기",
      "region": "daegu",
      "theme": ["festival", "healing", "date"]
    },
    {
      "content": "대구단편영화제에서 다양한 단편영화 관람하기",
      "region": "daegu",
      "theme": ["festival", "hist"]
    },
    {
      "content": "대구국제호러축제에서 무서운 귀신들을 보며 더위를 달래기",
      "region": "daegu",
      "theme": ["festival", "activity"]
    },
    {
      "content": "대구포크페스티벌에서 포크음악에 대한 매력에 빠져보기",
      "region": "daegu",
      "theme": ["festival", "hist"]
    },
    {
      "content": "대구 글로벌게임문화축제 e-Fun에서 여러나라의 게임 체험해보기",
      "region": "daegu",
      "theme": ["festival", "date"]
    },
    {
      "content": "대구음식관광박람회에서 다양한 음식관련 학습과 체험하고 맛있는 음식 먹어보기",
      "region": "daegu",
      "theme": ["festival", "food"]
    },
    {
      "content": "수성 건강 축제에서 건강해지는 다양한 방법 배우고 실천하기",
      "region": "daegu",
      "theme": ["festival"]
    },
    {
      "content": "대구수목원 국화 전시회에서 아름다운 국화 감상하기",
      "region": "daegu",
      "theme": ["festival", "healing", "date"]
    },
    {
      "content": "선사문화체험축제에서 선사시대에 대해서 공부하고 선사시대 장신구와 옷 입고 사진찍기",
      "region": "daegu",
      "theme": ["festival", "hist"]
    },
    {
      "content": "대구화교 중화문화축제에서 전통중국음식을 즐기기",
      "region": "daegu",
      "theme": ["festival", "hist"]
    },
    {
      "content": "서면 미술관에서 전시 관람하기",
      "region": "busan",
      "theme": ["hist", "date", "healing"]
    },
    {
      "content": "서면 캐니언파크에서 동물들 먹이주기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "서면 캐니언파크 실내카약장에서 카약 타기",
      "region": "busan",
      "theme": ["activity", "date"]
    },
    {
      "content": "서면 포차 거리에서 번호 따보기",
      "region": "busan",
      "theme": ["activity"]
    },
    {
      "content": "서면 포차 거리에서 밤새도록 술 마시기",
      "region": "busan",
      "theme": ["food"]
    },
    {
      "content": "롯데월드에서 교복 입고 로라의 성 앞에서 사진 찍기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "롯데월드에서 교복 입고 토킹트리 앞에서 사진 찍기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "롯데월드에서 퍼레이드 구경하기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "롯데월드 모든 놀이 기구 다 타보기",
      "region": "busan",
      "theme": ["date", "activity"]
    },
    {
      "content": "스카이라인루지에서 루지타보기",
      "region": "busan",
      "theme": ["date", "activity"]
    },
    {
      "content": "해운대 블루라인파크 해변 열차 타면서 경치 구경하기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "해운대 블루라인파크 스카이 캡슐 안에서 경치 구경하며 사진 찍기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "영도 흰 여울 문화마을 터널 앞 포토존에서 사진 찍기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "영도 흰 여울 문화마을 해녀 노상에서 바다 바라보며 회 먹기",
      "region": "busan",
      "theme": ["healing", "date", "food"]
    },
    {
      "content": "영도 흰 여울 문화마을에서 남항대교 뷰에서 노을 구경하기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "해운대 해수욕장에서 버스킹 해보기",
      "region": "busan",
      "theme": ["healing", "activity"]
    },
    {
      "content": "해운대 해수욕장에서 입술 파랗게 될 때까지 수영해 보기",
      "region": "busan",
      "theme": ["activity"]
    },
    {
      "content": "해운대 해수욕장에서 햇빛 받으면서 태닝하기",
      "region": "busan",
      "theme": ["healing"]
    },
    {
      "content": "해운대 동백섬에서 산책하기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "해운대 전통시장에서 줄 서서 호떡 사먹기",
      "region": "busan",
      "theme": ["date", "food"]
    },
    {
      "content": "해운대 더베이 101에서 물에 반사되는 사진 찍기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "해운대 요트 타면서 바다 구경하기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "해운대 클럽디 오아시스에서 물놀이 하기",
      "region": "busan",
      "theme": ["date", "activity"]
    },
    {
      "content": "해운대 해수욕장에서 새해 카운트 세기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "센텀 스파랜드에서 계란으로 머리 깨 먹기",
      "region": "busan",
      "theme": ["healing", "date", "food"]
    },
    {
      "content": "센텀 스파랜드에서 제일 뜨거운 방에서 오래 버텨보기",
      "region": "busan",
      "theme": ["activity"]
    },
    {
      "content": "기장 해동용궁사에서 바다 보며 소원 빌기",
      "region": "busan",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "롯데월드에 있는 모든 간식 다 한 입씩 먹어보기",
      "region": "busan",
      "theme": ["date", "food"]
    },
    {
      "content": "겨울에 해운대 해수욕장 입수하기",
      "region": "busan",
      "theme": ["activity"]
    },
    {
      "content": "광안대교를 배경으로 사진 찍기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "광안대교 오션뷰 숙소에서 룸 파티 하기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "수많은 인파들과 광안리 불꽃축제 즐기기",
      "region": "busan",
      "theme": ["date", "festival"]
    },
    {
      "content": "전날 대선 마시고 밀면으로 해장하기",
      "region": "busan",
      "theme": ["food"]
    },
    {
      "content": "전날 대선 마시고 국밥거리에서 국밥으로 해장하기",
      "region": "busan",
      "theme": ["food"]
    },
    {
      "content": "감천 문화마을 이장님이 됐다는 느낌으로 한 바퀴 걸어보기",
      "region": "busan",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "석불사 석불암 앞에서 스님의 목탁소리를 들으며 잠시 일상의 걱정거리를 잊어보기",
      "region": "busan",
      "theme": ["healing", "hist"]
    },
    {
      "content": "금정산성에서 옛 조상님들의 의기와 혼을 느껴보기",
      "region": "busan",
      "theme": ["healing", "hist"]
    },
    {
      "content": "영도 등대에서 태종대를 한눈에 담아보기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "다이아몬드 타워에서 부산의 야경을 소박하게 즐기기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "송도 해상 케이블카 타고 바다 위를 날아보기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "유리 바닥으로 된 송도 구름 산책로에서 마치 바다 위를 걷는다는 느낌 받아보기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "광안리 해수욕장 모래사장에 하트구멍 만들어서 인싸 사진 찍기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "식스팩 복근 만들어서 광안리 해수욕장에서 수영하기",
      "region": "busan",
      "theme": ["activity", "date"]
    },
    {
      "content": "송도 용궁 구름다리에서 담력 테스트 하기",
      "region": "busan",
      "theme": ["activity", "date"]
    },
    {
      "content": "해리단길에서 조금은 다른 부산을 느껴보기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "삼정 더 파크에서 나를 닮은 동물 찾아보기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "고요하고 정취 있는 범어사에서 내면을 돌아보고 참된 나를 찾아보기",
      "region": "busan",
      "theme": ["healing", "hist"]
    },
    {
      "content": "부산근대역사관에서 한 번쯤은 부산의 근현대에 대해 알아보기",
      "region": "busan",
      "theme": ["hist"]
    },
    {
      "content": "보수동 헌책방 골목에서 마음에 드는 책 한권 구입하기",
      "region": "busan",
      "theme": ["date", "hist"]
    },
    {
      "content": "국제시장에서 영화에 나온 명소 찾아보기",
      "region": "busan",
      "theme": ["date", "hist"]
    },
    {
      "content": "국제시장에서 길거리 음식으로 한끼 떼우기",
      "region": "busan",
      "theme": ["food", "date"]
    },
    {
      "content": "동백섬에서 일주 걷기 성공하기",
      "region": "busan",
      "theme": ["activity", "date"]
    },
    {
      "content": "동백 공원에서 만개한 동백꽃으로 인생샷 찍기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "부산여행 브이로그 촬영해보기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "부산 사투리 배워서 가게에서 써먹어보기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "아미산 전망대에서 일몰 감상하기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "다대포 꿈의 낙조분수 공연 보기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "부산역이 보이게 인증샷 찍기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "이케아에서 쇼룸 구경하기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "이케아 식당에서 맛있는거 먹기",
      "region": "busan",
      "theme": ["food", "healing", "date"]
    },
    {
      "content": "이케아 1층 통로에서 강아지인형 들고 인생샷 찍기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "부산국제영화제에서 레드카펫 위 연예인들 구경하기",
      "region": "busan",
      "theme": ["festival"]
    },
    {
      "content": "부산국제영화제에서 다양한 세계영화 구경하기",
      "region": "busan",
      "theme": ["healing", "date", "festival"]
    },
    {
      "content": "동항성당에서 예수상과 야경 구경하기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "부산전통문화체험관에서 우리나라 고유 무술 택견배우고 친구한테 기술 써보기",
      "region": "busan",
      "theme": ["activity", "hist"]
    },
    {
      "content": "송도 해상케이블카 타임캡슐에서 추억의 물건 넣기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "청사포 고양이마을에서 길고양이에게 츄르주기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "이기대 몽돌해변에서 예쁜 돌 줍기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "광안리에서 요트타고 불꽃놀이하기",
      "region": "busan",
      "theme": ["activity", "healing", "date"]
    },
    {
      "content": "임시수도기념관에서 6.25전쟁 역사의 한페이지를 바라보기",
      "region": "busan",
      "theme": ["hist"]
    },
    {
      "content": "을숙도 생태공원에서 천연기념물 새들 구경하기",
      "region": "busan",
      "theme": ["healing"]
    },
    {
      "content": "누리마루APEC에서 대한민국 정상자리 찾기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "기장 멸치축제에서 멸치회 먹어보기",
      "region": "busan",
      "theme": ["food", "festival"]
    },
    {
      "content": "부산 솔로몬로파크에서 교도소 체험해보기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "부산전통문화체험관에서 다도체험하면서 차 마시는 예절 배우기",
      "region": "busan",
      "theme": ["hist", "date"]
    },
    {
      "content": "오륙도 스카이워크에서 자신만만한 워킹하기",
      "region": "busan",
      "theme": ["activity", "date"]
    },
    {
      "content": "오륙도 해맞이공원에서 만개한 수선화 사이에서 사진찍기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "부산해양박물관에서 억울한 가오리 사진찍기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "아홉산숲 대나무숲에서 판다 찾기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "브릭캠퍼스에서 레고로 만든 작품들 감상하기",
      "region": "busan",
      "theme": ["date", "hist"]
    },
    {
      "content": "광안리해수욕장에서 밤에 웅장한 드론쇼 보기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "해양사자연박물관에서 닥터피쉬로 각질 제거하기",
      "region": "busan",
      "theme": ["date", "hist", "healing"]
    },
    {
      "content": "해양사자연박물관에서 대형고래동상앞에서 사진찍기",
      "region": "busan",
      "theme": ["date", "hist"]
    },
    {
      "content": "이기대 수변공원 반딧불이축제에서 반딧불이 빛나는 사진 찍기",
      "region": "busan",
      "theme": ["date", "festival"]
    },
    {
      "content": "을숙도생태공원에서 자전거빌려서 산책하기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "영도대교 도개장면 구경하기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "차이나타운에서 중국음식 먹기",
      "region": "busan",
      "theme": ["food", "healing", "date"]
    },
    {
      "content": "녹산고향동산에서 차크닉하기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "용두산공원 꽃시계 앞에서 인증샷 찍기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "태종대 공원에서 환상적인 해안 절경 감상하기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "자갈치 시장에서 해물빵 먹어보기",
      "region": "busan",
      "theme": ["food"]
    },
    {
      "content": "맑은 날에 부산타워에서 대마도 찾아보기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "자갈치 시장에서 해산물 이름 맞춰보기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "BIFF 광장에서 핸드프린팅 구경하기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "청사포 다릿돌 전망대에서 다릿돌 보며 소원 빌기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "해운대 수목원에서 방목하는 동물 찾아보기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "씨라이프 아쿠아리움에서 투명보트 타고 상어 먹이주기",
      "region": "busan",
      "theme": ["activity", "date"]
    },
    {
      "content": "영화의 전당에서 무대인사 보기",
      "region": "busan",
      "theme": ["date", "hist"]
    },
    {
      "content": "뮤지엄 원에서 LED 전시 관람하기",
      "region": "busan",
      "theme": ["date", "hist", "healing"]
    },
    {
      "content": "해운대 더베이 101에서 요트 투어하기",
      "region": "busan",
      "theme": ["date", "healing"]
    },
    {
      "content": "라이언 홀리데이에서 캐릭터와 사진 찍기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "해리단길에서 숨은 벽화 찾아보기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "다대포 해수욕장에서 조개와 꽃게 잡아보기",
      "region": "busan",
      "theme": ["activity", "date"]
    },
    {
      "content": "다대포 해수욕장에서 두꺼비집 짓기",
      "region": "busan",
      "theme": ["activity", "date"]
    },
    {
      "content": "부산과학체험관에서 다양한 체험 해보기 ",
      "region": "busan",
      "theme": ["hist", "date"]
    },
    {
      "content": "부산민주공원에서 역사에 대해 알아보기",
      "region": "busan",
      "theme": ["hist"]
    },
    {
      "content": "부산 장미원에서 만개한 장미꽃 구경하기",
      "region": "busan",
      "theme": ["date", "healing"]
    },
    {
      "content": "팥빙수 골목에서 시원한 팥빙수 즐기기",
      "region": "busan",
      "theme": ["date", "food"]
    },
    {
      "content": "우암동 도시숲 전망대에서 영도 바다와 부산항대교 한눈에 담아보기",
      "region": "busan",
      "theme": ["date", "healing"]
    },
    {
      "content": "우암동 도시 달빛 조형물 앞에서 기념샷 찍기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "40계단문화관에서 역사 전시 관람하기",
      "region": "busan",
      "theme": ["hist"]
    },
    {
      "content": "40계단거리에서 계단가위바위보 하며 오르기",
      "region": "busan",
      "theme": ["date"]
    },
    {
      "content": "해운대 해수욕장에서 갈매기한테 새우깡 주기",
      "region": "busan",
      "theme": ["date", "activity"]
    },
    {
      "content": "부산문화회관에서 사진 전시회 관람하기",
      "region": "busan",
      "theme": ["date", "healing"]
    },
    {
      "content": "황령산 봉수대에서 야경 보기",
      "region": "busan",
      "theme": ["date", "healing"]
    },
    {
      "content": "백양농원에서 올챙이 잡아보기",
      "region": "busan",
      "theme": ["activity", "date"]
    },
    {
      "content": "대변항에서 낚시로 물고기 잡아보기",
      "region": "busan",
      "theme": ["activity", "date"]
    },
    {
      "content": "국내 최대 뮤지컬 전용극장 드림씨어터에서 세계적 공연보기",
      "region": "busan",
      "theme": ["hist"]
    },
    {
      "content": "광안대교를 보며 패들보트타기 ",
      "region": "busan",
      "theme": ["activity"]
    },
    {
      "content": "맥도생태공원에서 자연을 느끼며 맥도날드 햄버거 먹기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "부산현대미술관에서 다양한 전시 구경하기",
      "region": "busan",
      "theme": ["hist", "date"]
    },
    {
      "content": "복합문화공간 F1963에서 하루 즐기기",
      "region": "busan",
      "theme": ["date", "hist"]
    },
    {
      "content": "부산커피박물관에서 다양한 원두 구경하고 원하는 원두로 커피 마시기",
      "region": "busan",
      "theme": ["food", "healing", "date"]
    },
    {
      "content": "화명수목원에서 자연의 피톤치드 느끼기",
      "region": "busan",
      "theme": ["healing", "date"]
    },
    {
      "content": "부산연등축제에서 아름다운 연등불빛과 야경 즐기기",
      "region": "busan",
      "theme": ["healing", "date", "festival"]
    },
    {
      "content": "부산국제코미디페스티벌에서 코미디공연보며 마음껏 웃기",
      "region": "busan",
      "theme": ["healing", "festival"]
    },
    {
      "content": "센텀맥주축제에서 다양한 맥주를 마시며 기분좋게 취하기",
      "region": "busan",
      "theme": ["healing", "food", "festival"]
    },
    {
      "content": "부산국제록페스티벌에서 록들으며 신나게 뛰기",
      "region": "busan",
      "theme": ["activity", "festival"]
    },
    {
      "content": "한강에서 한강라면 먹어보기",
      "region": "seoul",
      "theme": ["healing", "food"]
    },
    {
      "content": "롯데월드에서 할로윈 분장하고 축제 즐기기",
      "region": "seoul",
      "theme": ["festival"]
    },
    {
      "content": "잠실 야구장에서 홈런볼 잡아보기",
      "region": "seoul",
      "theme": ["date", "activity"]
    },
    {
      "content": "롯데월드에서 퍼레이드 구경하기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "롯데월드 모든 놀이 기구 다 타보기",
      "region": "seoul",
      "theme": ["activity", "date"]
    },
    {
      "content": "광장시장에서 구제 옷 쇼핑하기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "광장시장에서 먹거리 투어하기",
      "region": "seoul",
      "theme": ["food", "date"]
    },
    {
      "content": "광장시장에서 만 원의 행복 즐기기",
      "region": "seoul",
      "theme": ["food", "date"]
    },
    {
      "content": "한강 푸드트럭에서 다회용기 포장 해보기",
      "region": "seoul",
      "theme": ["date", "food"]
    },
    {
      "content": "한강에서 노을 보며 전동 바이크 타기",
      "region": "seoul",
      "theme": ["date", "activity", "healing"]
    },
    {
      "content": "한강에 도시락 싸가서 피크닉 하기",
      "region": "seoul",
      "theme": ["date", "food", "healing"]
    },
    {
      "content": "한강에서 물멍하면서 생각 정리하기",
      "region": "seoul",
      "theme": ["healing"]
    },
    {
      "content": "뚜벅뚜벅 축제에서 5만보 걷기",
      "region": "seoul",
      "theme": ["activity", "festival"]
    },
    {
      "content": "한강에서 야간 라이딩 해보기",
      "region": "seoul",
      "theme": ["activity", "date"]
    },
    {
      "content": "한강에서 야경 보며 시원한 맥주 마시기",
      "region": "seoul",
      "theme": ["healing", "date", "food"]
    },
    {
      "content": "한강에서 차박 해보기",
      "region": "seoul",
      "theme": ["activity", "date", "healing"]
    },
    {
      "content": "날씨 좋은 날 한강에서 요트 투어하기",
      "region": "seoul",
      "theme": ["activity", "date", "healing"]
    },
    {
      "content": "한강에서 아침 조깅하기",
      "region": "seoul",
      "theme": ["activity", "healing"]
    },
    {
      "content": "한강 수영 대회 참가 해보기",
      "region": "seoul",
      "theme": ["activity", "festival"]
    },
    {
      "content": "한강 멍 때리기 대회에서 상 받아보기",
      "region": "seoul",
      "theme": ["activity", "festival"]
    },
    {
      "content": "한강 마라톤 안쉬고 완주하기",
      "region": "seoul",
      "theme": ["activity", "festival"]
    },
    {
      "content": "별마당 도서관에서 책 읽어보기",
      "region": "seoul",
      "theme": ["healing", "date"]
    },
    {
      "content": "남산타워에서 케이블카 타보기",
      "region": "seoul",
      "theme": ["date", "healing"]
    },
    {
      "content": "남산타워 전망대에서 야경 보기",
      "region": "seoul",
      "theme": ["date", "healing"]
    },
    {
      "content": "남산타워에서 사랑의 자물쇠 걸어보기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "롯데타워 전망대에서 야경 보기",
      "region": "seoul",
      "theme": ["healing", "date"]
    },
    {
      "content": "안국에서 고궁 투어 해보기",
      "region": "seoul",
      "theme": ["hist", "date"]
    },
    {
      "content": "청계천에서 물에 발 담그고 놀기",
      "region": "seoul",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "동묘 구제시장에서 구제 옷 한벌 맞추고 패션쇼하기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "양화대교 건너면서 자이언티의 양화대교 노래 듣기",
      "region": "seoul",
      "theme": ["healing"]
    },
    {
      "content": "경복궁에서 한복입고 구경하기",
      "region": "seoul",
      "theme": ["date", "hist"]
    },
    {
      "content": "광화문광장에서 이순신 장군과 세종대왕님에게 인사하기",
      "region": "seoul",
      "theme": ["hist"]
    },
    {
      "content": "노량진 수산물시장에서 회 사면서 서비스 받기",
      "region": "seoul",
      "theme": ["food", "date"]
    },
    {
      "content": "청와대 구경하기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "노량진 컵밥거리에서 맛있는 컵밥먹기",
      "region": "seoul",
      "theme": ["date", "healing", "food"]
    },
    {
      "content": "통인시장에서 엽전으로 먹거리 사먹기",
      "region": "seoul",
      "theme": ["date", "healing", "food"]
    },
    {
      "content": "동대문 DDP에서 모델처럼 옷 입고 사진찍기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "석촌호수 걸으면서 산책하기",
      "region": "seoul",
      "theme": ["healing", "date"]
    },
    {
      "content": "서촌에서 한옥 구경하기",
      "region": "seoul",
      "theme": ["hist", "date", "healing", "hist"]
    },
    {
      "content": "서촌 감성카페에서 인생샷 찍기",
      "region": "seoul",
      "theme": ["date", "healing"]
    },
    {
      "content": "덕수궁 돌담길을 거닐며 사진 찍기",
      "region": "seoul",
      "theme": ["date", "healing", "hist"]
    },
    {
      "content": "회기역 파전골목에서 비올때 막거리에 파전먹기",
      "region": "seoul",
      "theme": ["healing", "date", "food"]
    },
    {
      "content": "한강 수상택시타보기",
      "region": "seoul",
      "theme": ["date", "activity"]
    },
    {
      "content": "한강 유람선타고 야경보기",
      "region": "seoul",
      "theme": ["healing", "date", "activity"]
    },
    {
      "content": "서울숲 메타세콰이아길에서 인생샷 찍기",
      "region": "seoul",
      "theme": ["healing", "date"]
    },
    {
      "content": "익선동 한옥거리에서 감성  카페 가기",
      "region": "seoul",
      "theme": ["healing", "date"]
    },
    {
      "content": "연남동 소품샵투어하면서 예쁜 소품 사기",
      "region": "seoul",
      "theme": ["healing", "date"]
    },
    {
      "content": "충무로에서 연극 보기",
      "region": "seoul",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "서울대학교 정문 샤에서 사진찍기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "장충동에서 왕족발 먹기",
      "region": "seoul",
      "theme": ["food", "healing", "date"]
    },
    {
      "content": "신당동에서 즉석떡볶이 먹기",
      "region": "seoul",
      "theme": ["food", "healing", "date"]
    },
    {
      "content": "용산 IMAX관에서 제일 큰 스크린으로 영화보기",
      "region": "seoul",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "마장동 축산시장에서 소고기 먹기",
      "region": "seoul",
      "theme": ["food", "healing", "date"]
    },
    {
      "content": "사당역에서 연인한테 사당해(사랑해)라고 하기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "올림픽공원 나홀로 나무에서 인생샷 찍기",
      "region": "seoul",
      "theme": ["healing", "date"]
    },
    {
      "content": "낙산성곽 둘레길 산책하기",
      "region": "seoul",
      "theme": ["healing", "date"]
    },
    {
      "content": "난지 한강공원에서 청춘페스티벌 즐기기",
      "region": "seoul",
      "theme": ["festival", "date"]
    },
    {
      "content": "장미축제에서 예쁜 장미와 함께 인생샷 찍기",
      "region": "seoul",
      "theme": ["date", "festival"]
    },
    {
      "content": "경복궁에서 한복 입고 야경투어 하기",
      "region": "seoul",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "한남동 리움미술관에서 전시 관람하기",
      "region": "seoul",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "원마운트 워터파크에서 물놀이 즐기기",
      "region": "seoul",
      "theme": ["activity", "date"]
    },
    {
      "content": "별마당 도서관에서 친구에게 어울릴만한 책 추천해 주기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "서울로 7017에서 서울의 랜드마크를 구경하며 산책하기 ",
      "region": "seoul",
      "theme": ["healing", "date"]
    },
    {
      "content": "아모레퍼시픽 미술관에서 전시 관람하기",
      "region": "seoul",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "인사동 LP카페에서 내가 좋아하는 노래 LP판 구매하기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "인사동 LP카페에서 제일 오래된 LP판 찾아보기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "서울식물원에서 식물들 이름 맞춰보기",
      "region": "seoul",
      "theme": ["date", "hist"]
    },
    {
      "content": "국립현대미술관에서 전시 구경하기",
      "region": "seoul",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "더현대 서울에서 매월마다 다른 사운즈 포레스트 구경하며 인증샷 찍기",
      "region": "seoul",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "명동 만화의 집에서 좋아하는 만화책 시리즈 다 보기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "명동 만화의 집에서 DVD 보기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "인왕산 숲속 쉼터에서 숲속 한가운데 있는 느낌 받아보기",
      "region": "seoul",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "금성오락실에서 추억의 게임하기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "서울스카이 전망대에서 서울 한눈에 내려다보기",
      "region": "seoul",
      "theme": ["healing", "date"]
    },
    {
      "content": "톤앤뮤직 페스티벌 피크닉 존에서 맥주 마시며 음악 즐기기",
      "region": "seoul",
      "theme": ["date", "festival"]
    },
    {
      "content": "워터밤 축제에서 모르는 사람들과 물총 쏘며 놀기",
      "region": "seoul",
      "theme": ["activity", "festival"]
    },
    {
      "content": "서울 불꽃놀이 명당자리에 앉아 불꽃놀이 구경하기",
      "region": "seoul",
      "theme": ["activity", "festival", "date"]
    },
    {
      "content": "원신 서울 여름축제에서 코스프레 해보기",
      "region": "seoul",
      "theme": ["festival"]
    },
    {
      "content": "원신 서울 여름축제에서 코스프레 한 사람이랑 같이 사진 찍기",
      "region": "seoul",
      "theme": ["date", "festival"]
    },
    {
      "content": "봉은사 명상길에서 바람을 느끼며 자연 속에서 생각 정리하기",
      "region": "seoul",
      "theme": ["healing", "hist"]
    },
    {
      "content": "맥주축제에서 다양한 수제 맥주 마셔보기",
      "region": "seoul",
      "theme": ["festival"]
    },
    {
      "content": "북한산계곡에서 물소리 들으며 전에 막걸리 마시기",
      "region": "seoul",
      "theme": ["healing", "date", "food"]
    },
    {
      "content": "롯데월드 아이스 링크장에서 스피드 스케이팅 자세하며 달려보기",
      "region": "seoul",
      "theme": ["activity", "date"]
    },
    {
      "content": "강남 실탄사격장에서 완벽한 자세로 사격해 보기",
      "region": "seoul",
      "theme": ["activity", "date"]
    },
    {
      "content": "용마폭포공원에서 웅장한 인공폭포 구경하기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "레트로 슈퍼 콘서트에서 복고 의상 입고 콘서트 관람하기",
      "region": "seoul",
      "theme": ["festival", "date"]
    },
    {
      "content": "하늘공원에서 노을질때 그림같은 사진 찍기",
      "region": "seoul",
      "theme": ["date", "healing"]
    },
    {
      "content": "바쁜 도심 생활은 잠시 잊고 마음 편히 청계천 산책하기",
      "region": "seoul",
      "theme": ["date", "healing"]
    },
    {
      "content": "젊음의 거리인 종각에 가서 젊음을 느껴보기",
      "region": "seoul",
      "theme": ["date", "healing"]
    },
    {
      "content": "탑골공원에 가서 대한민국의 자주 독립정신 느껴보기",
      "region": "seoul",
      "theme": ["hist"]
    },
    {
      "content": "인사동에서 전통찻집,전통공예품 매장 등에 가서 한국의 전통을 느껴보기",
      "region": "seoul",
      "theme": ["hist", "date"]
    },
    {
      "content": "유네스코 세계문화유산인 종묘 관람하기",
      "region": "seoul",
      "theme": ["hist", "date"]
    },
    {
      "content": "조선시대의 왕이 되었다는 느낌으로 창덕궁 정원 산책하기",
      "region": "seoul",
      "theme": ["hist", "healing"]
    },
    {
      "content": "창덕궁에서 우리나라 전통 문화 체험 해보기",
      "region": "seoul",
      "theme": ["hist", "date"]
    },
    {
      "content": "내 옷 중 가장 힙한 옷 입고 홍대에서 놀기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "우리 지역에는 없는 서울의 장점 하나 찾아보기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "전쟁기념관에서 한국전쟁과 관련된 역사 알아보기",
      "region": "seoul",
      "theme": ["hist", "date"]
    },
    {
      "content": "서울대공원에서 나를 닮은 동물 찾아보기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "서울 지하철에서 바쁘게 사는 사람들을 보고 동기부여 받기",
      "region": "seoul",
      "theme": ["healing"]
    },
    {
      "content": "올림픽 공원 텐트빌리지에서 도심속에서 캠핑 즐기기",
      "region": "seoul",
      "theme": ["healing", "date", "activity"]
    },
    {
      "content": "서울 시내 곳곳에 설치된 자전거도로를 이용해 시티뷰와 함께 시원한 바람 즐기기",
      "region": "seoul",
      "theme": ["healing", "activity"]
    },
    {
      "content": "지하철 스탬프 투어 완주하기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "북촌 한옥마을에서 조선 시대 한옥 모습 느껴보기",
      "region": "seoul",
      "theme": ["date", "hist"]
    },
    {
      "content": "명동난타극장에서 난타 공연 보면서 스트레스 풀기",
      "region": "seoul",
      "theme": ["date", "healing", "hist"]
    },
    {
      "content": "이화 벽화마을에서 천사 날개 달고 사진 찍기",
      "region": "seoul",
      "theme": ["date", "hist"]
    },
    {
      "content": "63빌딩 마라톤 참가해보기",
      "region": "seoul",
      "theme": ["activity"]
    },
    {
      "content": "63빌딩 정상 찍어보기",
      "region": "seoul",
      "theme": ["activity"]
    },
    {
      "content": "한 번쯤은 케이블카 타지 않고 남산 올라가기",
      "region": "seoul",
      "theme": ["activity"]
    },
    {
      "content": "여의도 공원에서 인라인스케이트 타기",
      "region": "seoul",
      "theme": ["activity"]
    },
    {
      "content": "여의도 공원 한바퀴 산책하기",
      "region": "seoul",
      "theme": ["date", "healing"]
    },
    {
      "content": "마곡 서울식물원에서 선물할 식물 하나 사기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "공부보단 힐링 느낌으로 국립중앙박물관 구경하기",
      "region": "seoul",
      "theme": ["healing", "hist"]
    },
    {
      "content": "남산골 한옥마을에서 돌쇠 흉내 내보기",
      "region": "seoul",
      "theme": ["date", "hist"]
    },
    {
      "content": "조계사에서 수령이 500년인 백송과 회화나무를 바라보면서 겸손한 마음가짐 갖기",
      "region": "seoul",
      "theme": ["healing", "hist"]
    },
    {
      "content": "적어도 한국인이라면 국보 1호 숭례문 한번은 가보기",
      "region": "seoul",
      "theme": ["hist"]
    },
    {
      "content": "명동성당에서 천주교회의 훌륭한 건축 양식 엿보기",
      "region": "seoul",
      "theme": ["hist"]
    },
    {
      "content": "더현대서울에서 하루종일 쇼핑하고 맛있는거 먹기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "지하철 아무거나 타고 아무곳에서 내려서 데이트하기",
      "region": "seoul",
      "theme": ["date"]
    },
    {
      "content": "노들섬 핑크노을 아래에서 인생샷 건지기",
      "region": "seoul",
      "theme": ["date", "healing"]
    },
    {
      "content": "산리오러버스클럽에서 좋아하는 산리오캐릭터와 사진찍기",
      "region": "seoul",
      "theme": ["date", "healing"]
    },
    {
      "content": "창경궁 대온실에서 온실 속 화초들 구경하기",
      "region": "seoul",
      "theme": ["date", "healing", "hist"]
    },
    {
      "content": "야간개장한 창경궁에서 아름다운 창경궁의 야경 구경하기",
      "region": "seoul",
      "theme": ["date", "hist"]
    },
    {
      "content": "메이드카페가서 맛있어지는 주문 음식에게 하고 맛있게 먹기",
      "region": "seoul",
      "theme": ["food", "healing"]
    },
    {
      "content": "한달살이 해보기",
      "region": "jeju",
      "theme": ["healing"]
    },
    {
      "content": "사계해변 모래 구멍에 들어가서 사진 찍기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "전날 한라산 마시고,해물라면으로 해장하기",
      "region": "jeju",
      "theme": ["food"]
    },
    {
      "content": "무지개 해안 도로에서 드라이브하기 ",
      "region": "jeju",
      "theme": ["healing"]
    },
    {
      "content": "문도지 오름에서 말이랑 같이 셀카 찍기",
      "region": "jeju",
      "theme": ["healing", "date"]
    },
    {
      "content": "카페패스 사용해서 하루에 카페 2군데 이상 가서 뽕 뽑기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "오션뷰 카페에서 바다를 바라보며 코딩하기",
      "region": "jeju",
      "theme": ["healing"]
    },
    {
      "content": "로컬 흑돼지 맛집 찾아서 먹기",
      "region": "jeju",
      "theme": ["food"]
    },
    {
      "content": "게스트하우스 파티 가서 친구 사귀기",
      "region": "jeju",
      "theme": ["activity"]
    },
    {
      "content": "돌하르방이랑 똑같은 포즈로 사진 찍기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "김정희 유배지에 가서 유배 당한척 해보기",
      "region": "jeju",
      "theme": ["hist"]
    },
    {
      "content": "제주도 쇠소깍 가서 모르는 사람이랑 카약 경주하기",
      "region": "jeju",
      "theme": ["activity"]
    },
    {
      "content": "사려니숲길 가서 숲길 사이에서 사진 찍기",
      "region": "jeju",
      "theme": ["healing", "date"]
    },
    {
      "content": "이호테우해변에서 바다의 향기를 느끼며 산책하기",
      "region": "jeju",
      "theme": ["healing"]
    },
    {
      "content": "함덕해수욕장 모래사장에 하트구멍 만들어서 인싸 사진 찍기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "성산일출봉에서 제주도에서 가장 먼저 뜨는 해 보기",
      "region": "jeju",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "동문 야시장에서 상의 없이 각자 메뉴 1개씩 사 와서 나눠 먹기",
      "region": "jeju",
      "theme": ["date", "food"]
    },
    {
      "content": "서귀포 야시장에서 상의 없이 각자 메뉴 1개씩 사 와서 나눠 먹기",
      "region": "jeju",
      "theme": ["date", "food"]
    },
    {
      "content": "동문 시장에서 가족이랑 친구들 나눠줄 기념품 사기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "제주 공항에서 마음 샌드 구매 성공하기",
      "region": "jeju",
      "theme": ["date", "food"]
    },
    {
      "content": "목적지 정해놓지 않고 해안 도로 드라이브하기",
      "region": "jeju",
      "theme": ["healing", "date"]
    },
    {
      "content": "우도의 땅콩은 정말로 더 맛있는지 확인해 보기",
      "region": "jeju",
      "theme": ["date", "food"]
    },
    {
      "content": "제주도 사계절 사진 찍기",
      "region": "jeju",
      "theme": ["healing", "date"]
    },
    {
      "content": "천지연 폭포에서 튀기는 물 맞아보기",
      "region": "jeju",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "민속 자연사 박물관에서 한 번쯤은 제주도의 자연에 대해서 공부해 보기",
      "region": "jeju",
      "theme": ["date", "hist"]
    },
    {
      "content": "전복 풀코스 요리 먹기",
      "region": "jeju",
      "theme": ["healing", "date", "food"]
    },
    {
      "content": "테디베어 뮤지엄 가서 동심으로 돌아가기",
      "region": "jeju",
      "theme": ["healing", "date", "hist"]
    },
    {
      "content": "섭지코지에서 인생샷 건져서 카톡 프사하기",
      "region": "jeju",
      "theme": ["healing", "date"]
    },
    {
      "content": "제주공항 입구 Hello Jeju에서 제주도 왔다는 인증샷 찍기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "사려니 숲길에서 웨딩 사진 찍기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "협재 해수욕장에서 비키니 입고 수영하기",
      "region": "jeju",
      "theme": ["activity"]
    },
    {
      "content": "쇠소깍에서 나룻배 카약 타보기",
      "region": "jeju",
      "theme": ["activity", "date"]
    },
    {
      "content": "자연이 만든 예술작품 주상절리대 감상하기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "용연 구름다리에서 인생샷 건지기",
      "region": "jeju",
      "theme": ["date", "healing"]
    },
    {
      "content": "비 오는 날 엉또폭포에서 거대한 폭포 보기",
      "region": "jeju",
      "theme": ["healing", "date"]
    },
    {
      "content": "오설록 티 뮤지엄에서 녹차밭 구경하기",
      "region": "jeju",
      "theme": ["date", "hist"]
    },
    {
      "content": "오설록 티 뮤지엄에서 녹차 디저트 먹어보기",
      "region": "jeju",
      "theme": ["food", "date", "hist"]
    },
    {
      "content": "사려니숲길 코스 걸어보기",
      "region": "jeju",
      "theme": ["healing", "date"]
    },
    {
      "content": "도치돌 알파카 목장에서 알파카 먹이주기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "도치돌 알파카 목장에서 알파카랑 사진 찍기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "현무암 탄생석 팔찌 커플로 맞추기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "섭지코지 그랜드 스윙 포토존에서 사진 찍기",
      "region": "jeju",
      "theme": ["date", "healing"]
    },
    {
      "content": "제주목 관아에서 역사 문화 체험하기",
      "region": "jeju",
      "theme": ["hist", "date"]
    },
    {
      "content": "하도 어촌체험마을에서 해녀체험하기",
      "region": "jeju",
      "theme": ["activity"]
    },
    {
      "content": "자전거 해안 도로에서 전동 바이크 타기",
      "region": "jeju",
      "theme": ["date", "healing", "activity"]
    },
    {
      "content": "제주 올레길 모든 코스 완주하기",
      "region": "jeju",
      "theme": ["activity"]
    },
    {
      "content": "제주 여행 브이로그 찍어보기",
      "region": "jeju",
      "theme": ["date", "healing"]
    },
    {
      "content": "혼자 제주도 여행하기",
      "region": "jeju",
      "theme": ["healing"]
    },
    {
      "content": "한라산 등반하기",
      "region": "jeju",
      "theme": ["activity", "date"]
    },
    {
      "content": "한라산 정상에서 한라산 술들고 기념사진 찍기",
      "region": "jeju",
      "theme": ["activity", "date"]
    },
    {
      "content": "눈 쌓인 곳에서 썰매 타보기",
      "region": "jeju",
      "theme": ["activity", "date"]
    },
    {
      "content": "제주 엽서에 편지 써서 선물하기",
      "region": "jeju",
      "theme": ["healing"]
    },
    {
      "content": "필름 카메라 제주 풍경으로만 가득 채우기",
      "region": "jeju",
      "theme": ["healing"]
    },
    {
      "content": "차 없이 뚜벅이로 여행하기",
      "region": "jeju",
      "theme": ["healing"]
    },
    {
      "content": "제주도민 친구한테 제주도 방언 배우기",
      "region": "jeju",
      "theme": ["healing"]
    },
    {
      "content": "제주도민 친구 만들기",
      "region": "jeju",
      "theme": ["healing"]
    },
    {
      "content": "제주도민한테 로컬 맛집 추천받기",
      "region": "jeju",
      "theme": ["food"]
    },
    {
      "content": "일몰시간에 이호테우해변에서 사진 찍기",
      "region": "jeju",
      "theme": ["date", "healing"]
    },
    {
      "content": "애월 한담 해안 산책로에서 곽지리 해변까지 산책로를 따라 산책하기",
      "region": "jeju",
      "theme": ["date", "healing"]
    },
    {
      "content": "제주 양떼 목장에서 귀여운 양들에게 먹이주기",
      "region": "jeju",
      "theme": ["date", "healing"]
    },
    {
      "content": "제주 양떼 목장에서 양들과 함께 셀카 찍기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "제주 양떼 목장에 늑대 옷 입고 가보기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "구엄리 돌염전에서 인근 바위에 앉아 일몰 구경하기",
      "region": "jeju",
      "theme": ["date", "healing"]
    },
    {
      "content": "이호테우해변에서 목마 등대 포토존 앞에서 인증샷 찍기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "알작지해변에서 제일 동글동글한 돌 찾아보기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "사진놀이터에서 테마에 맞춰 다양한 포즈로 사진 찍어보기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "사진놀이터에서 테마에 맞춰 어울리는 드라마 대사로 상황극 해보기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "애월 카페거리에서 오션뷰 바라보며 커피 마시기",
      "region": "jeju",
      "theme": ["date", "healing"]
    },
    {
      "content": "수월봉 지질 트레일 코스를 둘러보며 생생하게 남아있는 화산 쇄설층 구경하기",
      "region": "jeju",
      "theme": ["date", "hist"]
    },
    {
      "content": "제주 사투리 쓰며 제주도민인척해 보기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "금오름에 올라가서 제주 시내와 멀리 바다까지 한눈에 구경하기",
      "region": "jeju",
      "theme": ["date", "healing"]
    },
    {
      "content": "비 온 다음 날 금오름에 올라가 분화구에 물이 고인 모습 보기",
      "region": "jeju",
      "theme": ["date", "hist"]
    },
    {
      "content": "정방폭포에서 폭포와 함께 무지개 사진 찍어보기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "한라산 소주 공장에서 한라산 시음해 보기",
      "region": "jeju",
      "theme": ["food", "date", "hist"]
    },
    {
      "content": "한라산 소주 공장 옥상 정원에서 한라산과 비양도를 바라보며 사진 찍기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "넥슨컴퓨터 박물관에서 추억의 게임 즐겨보기",
      "region": "jeju",
      "theme": ["date", "hist", "activity"]
    },
    {
      "content": "그라나다에서 날고 있는 비행기와 함께 인생샷 남겨보기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "제주민속촌 무더위를 날릴 공포체험 해보기",
      "region": "jeju",
      "theme": ["date", "hist", "activity"]
    },
    {
      "content": "머메이드 다이빙 체험에서 바위에 앉아 인어공주인척하기",
      "region": "jeju",
      "theme": ["date", "activity"]
    },
    {
      "content": "아쿠아플라넷에서 스쿠버 다이빙하며 물고기와 아이컨택 해보기",
      "region": "jeju",
      "theme": ["date", "activity"]
    },
    {
      "content": "해녀체험하면서 물속에서 문어 들고 사진 찍어보기",
      "region": "jeju",
      "theme": ["date", "activity"]
    },
    {
      "content": "빅볼체험에서 언덕 굴러보기",
      "region": "jeju",
      "theme": ["date", "activity"]
    },
    {
      "content": "용머리해안에서 화산층을 배경으로 사진 찍기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "스누피가든에서 귀여운 스누피와 사진찍기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "아쿠아플라넷 제주에서 돌고래쇼 구경하기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "아쿠아플라넷 제주에서 나와 닮은 해양생물 찾기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "항공우주박물관에서 조종사 옷입고 전투기타고 사진 찍기",
      "region": "jeju",
      "theme": ["date", "hist"]
    },
    {
      "content": "거문오름에서 피톤치드 느끼기",
      "region": "jeju",
      "theme": ["healing", "date"]
    },
    {
      "content": "미로공원에서 빠른시간안에 미로 탈출하기",
      "region": "jeju",
      "theme": ["date", "activity"]
    },
    {
      "content": "카트타고 빠른 스피드 즐기기",
      "region": "jeju",
      "theme": ["activity", "date"]
    },
    {
      "content": "넥슨컴퓨터 박물관에서 넥슨캐쉬 충전하기",
      "region": "jeju",
      "theme": ["date", "hist"]
    },
    {
      "content": "넥슨컴퓨터 박물관에서 코딩체험하기",
      "region": "jeju",
      "theme": ["date", "hist"]
    },
    {
      "content": "피규어뮤지엄에서 마블 주인공들과 사진찍기",
      "region": "jeju",
      "theme": ["date", "hist"]
    },
    {
      "content": "도깨비도로에서 착시현상 느끼기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "감귤체험 농장에서 감귤따서 맛있게 먹기",
      "region": "jeju",
      "theme": ["food", "date", "activity"]
    },
    {
      "content": "잠수함타고 바닷속의 물고기들 구경하기",
      "region": "jeju",
      "theme": ["date", "activity"]
    },
    {
      "content": "아부오름 올라가면서 옆사람에게 아부하기",
      "region": "jeju",
      "theme": ["date", "activity"]
    },
    {
      "content": "루나폴에서 불빛 야경 즐기기",
      "region": "jeju",
      "theme": ["date", "healing"]
    },
    {
      "content": "만장굴에서 박쥐 찾아보기",
      "region": "jeju",
      "theme": ["date", "activity"]
    },
    {
      "content": "제주아트서커스에서 서커스보고 따라해보기",
      "region": "jeju",
      "theme": ["date", "activity"]
    },
    {
      "content": "헬로키티아일랜드에서 키티에게 인사하기",
      "region": "jeju",
      "theme": ["date", "healing", "hist"]
    },
    {
      "content": "화조원에서 독수리랑 눈싸움하기",
      "region": "jeju",
      "theme": ["date", "activity"]
    },
    {
      "content": "노형수퍼마켙에서 미디어아트 보기",
      "region": "jeju",
      "theme": ["date", "healing", "hist"]
    },
    {
      "content": "수목원 테마파크 아이스뮤지엄에서 시원한 얼음썰매타기",
      "region": "jeju",
      "theme": ["date", "activity"]
    },
    {
      "content": "승마체험장에서 말타면서 '이랴'하기",
      "region": "jeju",
      "theme": ["date", "activity"]
    },
    {
      "content": "창꼼바위 구멍사이에서 인생샷찍기",
      "region": "jeju",
      "theme": ["date", "healing"]
    },
    {
      "content": "동문시장에서 제주도 특산물 한라봉 사서 선물하기",
      "region": "jeju",
      "theme": ["food", "date"]
    },
    {
      "content": "올레시장에서 유명한 오메기떡 사먹기",
      "region": "jeju",
      "theme": ["food", "healing", "date"]
    },
    {
      "content": "배낚시하면서 잡은 해산물로 해물라면 만들어먹기",
      "region": "jeju",
      "theme": ["food", "healing", "activity"]
    },
    {
      "content": "영락리 돌고래스팟에서 야생돌고래 구경하기",
      "region": "jeju",
      "theme": ["healing", "date"]
    },
    {
      "content": "휴애리 수국축제에서 수국 사이에서 인생샷 찍기",
      "region": "jeju",
      "theme": ["healing", "date"]
    },
    {
      "content": "이상한 변호사 우영우 촬영지 관음사 가보기 ",
      "region": "jeju",
      "theme": ["hist", "date"]
    },
    {
      "content": "소인국테마파크에서 엄청 큰 전시물들과 함께 작은사람 된 기분 느끼기",
      "region": "jeju",
      "theme": ["hist", "date"]
    },
    {
      "content": "박물관은 살아있다에서 몰래 움직이는 전시품들 순간포착하기",
      "region": "jeju",
      "theme": ["hist", "date"]
    },
    {
      "content": "제주조천스위스마을에서 스위스에 온 척 사진찍기",
      "region": "jeju",
      "theme": ["date", "healing"]
    },
    {
      "content": "자동차박물관에서 옛날 클래식카들 구경하기",
      "region": "jeju",
      "theme": ["hist", "date"]
    },
    {
      "content": "제주별빛누리공원에서 천체망원경으로 내 별자리 보기",
      "region": "jeju",
      "theme": ["date"]
    },
    {
      "content": "초콜릿박물관에서 초콜릿만들기 체험하고 맛있게 먹기",
      "region": "jeju",
      "theme": ["food", "date"]
    },
    {
      "content": "구룡포근대문화거리에서 일본 가옥들 구경하고 일본 온 척 사진찍기",
      "region": "pohang",
      "theme": ["date", "hist"]
    },
    {
      "content": "구룡포근대문화거리 드라마 '동백꽃필무렵' 촬영장소에서 주인공처럼 사진찍기",
      "region": "pohang",
      "theme": ["date", "hist"]
    },
    {
      "content": "구룡포근대문화거리 추억의 느린 우체통에 미래의 나에게 편지쓰기",
      "region": "pohang",
      "theme": ["healing"]
    },
    {
      "content": "연오랑 세오녀 테마공원에서 쌍거북바위 구경하기",
      "region": "pohang",
      "theme": ["healing", "date"]
    },
    {
      "content": "연오랑 세오녀 테마공원에서 바다 구경하면서 산책하기",
      "region": "pohang",
      "theme": ["healing", "date"]
    },
    {
      "content": "죽도시장에서 대게 흥정해서 싸게 먹기",
      "region": "pohang",
      "theme": ["food"]
    },
    {
      "content": "스케이스워크 가장 높은곳까지 올라가서 인증샷 찍기",
      "region": "pohang",
      "theme": ["date", "activity"]
    },
    {
      "content": "해상스카이워크에서 유리 위로만 걷기",
      "region": "pohang",
      "theme": ["date", "activity"]
    },
    {
      "content": "해상스카이워크에서 바다를 파노라마로 사진 찍기",
      "region": "pohang",
      "theme": ["healing", "date"]
    },
    {
      "content": "보경사 5층 석탑 구경하기",
      "region": "pohang",
      "theme": ["date", "hist"]
    },
    {
      "content": "이가리닻전망대에서 바다 구경하기",
      "region": "pohang",
      "theme": ["date", "healing"]
    },
    {
      "content": "이가리닻전망대 동굴 포토존에서 사진찍기",
      "region": "pohang",
      "theme": ["date", "healing"]
    },
    {
      "content": "사방기념공원 돌탑에 돌쌓기",
      "region": "pohang",
      "theme": ["date"]
    },
    {
      "content": "사방기념공원 드라마 '갯마을차차차'에 나온 배 위에서 사진 찍기",
      "region": "pohang",
      "theme": ["date", "healing"]
    },
    {
      "content": "포항운하에서 유람선타면서 갈매기에게 새우깡주기",
      "region": "pohang",
      "theme": ["healing", "activity", "date"]
    },
    {
      "content": "포항운하에서 유람선 기다리면서 트릭아트 사진 찍기",
      "region": "pohang",
      "theme": ["healing", "date"]
    },
    {
      "content": "청하 5일장 오징어동상 앞에서 오징어들고 사진찍기",
      "region": "pohang",
      "theme": ["date"]
    },
    {
      "content": "청하시장에서 드라마 '갯마을차차차'에 나온 청호철물점 앞에서 사진찍기 ",
      "region": "pohang",
      "theme": ["date"]
    },
    {
      "content": "청하 5일장에서 호떡먹기",
      "region": "pohang",
      "theme": ["food"]
    },
    {
      "content": "포항 영일대 해수욕장에서 모래성 만들기",
      "region": "pohang",
      "theme": ["healing", "date"]
    },
    {
      "content": "영일대 위에 올라가서 바다 구경하기",
      "region": "pohang",
      "theme": ["healing", "date"]
    },
    {
      "content": "송도 솔밭길에서 솔방울 줍기",
      "region": "pohang",
      "theme": ["healing", "date"]
    },
    {
      "content": "호미곶에서 손바닥들고 사진찍기",
      "region": "pohang",
      "theme": ["date"]
    },
    {
      "content": "호미곶에서 일출보며 손바닥위에 해가 있을때 사진찍기",
      "region": "pohang",
      "theme": ["date"]
    },
    {
      "content": "곤륜산에서 패러글라이딩하며 포항을 한눈에 내려다보기",
      "region": "pohang",
      "theme": ["activity"]
    },
    {
      "content": "다무포하얀마을에서 벽화들을 구경하며 사진찍기",
      "region": "pohang",
      "theme": ["date", "healing"]
    },
    {
      "content": "다무포하얀마을을 산책하며 바다를 구경하기",
      "region": "pohang",
      "theme": ["date", "healing"]
    },
    {
      "content": "보릿돌교 중앙에서 인생샷 찍기",
      "region": "pohang",
      "theme": ["date"]
    },
    {
      "content": "호미곶해맞이광장 해바라기밭에서  인생샷 찍기",
      "region": "pohang",
      "theme": ["date", "healing"]
    },
    {
      "content": "요트타고 포항의 야경들을 바라보며 불꽃놀이하기",
      "region": "pohang",
      "theme": ["date", "activity"]
    },
    {
      "content": "park1538에서 미디어아트 전시 보기",
      "region": "pohang",
      "theme": ["date"]
    },
    {
      "content": "기청산수목원에서 연아송 앞에서 김연아 자세따라하고 사진찍기",
      "region": "pohang",
      "theme": ["date"]
    },
    {
      "content": "기청산수목원에서 새소리를 들으며 산책하기",
      "region": "pohang",
      "theme": ["date", "healing"]
    },
    {
      "content": "국제불빛축제에서 엄청난 불꽃놀이 구경하기",
      "region": "pohang",
      "theme": ["date", "festival"]
    },
    {
      "content": "park1538 전시관에서 대한민국 철의 발전과정 보기",
      "region": "pohang",
      "theme": ["date", "hist"]
    },
    {
      "content": "로보라이프뮤지엄에서 다양한 로봇들 조종하기 ",
      "region": "pohang",
      "theme": ["date", "activity", "hist"]
    },
    {
      "content": "첨성대에서 손바닥위에 첨성대 올리고 사진 찍기",
      "region": "gyeongju",
      "theme": ["date", "hist"]
    },
    {
      "content": "동궁과 월지에서 아름다운 야경을 배경으로 구경하면서 사진찍기",
      "region": "gyeongju",
      "theme": ["date", "hist"]
    },
    {
      "content": "대릉원에서 왕릉 사이에서 인생샷 찍기",
      "region": "gyeongju",
      "theme": ["date", "hist"]
    },
    {
      "content": "국립경주박물관가서 신라시대의 유물 감상하기",
      "region": "gyeongju",
      "theme": ["hist"]
    },
    {
      "content": "경주월드가서 제일 무서운 드라켄 타보기",
      "region": "gyeongju",
      "theme": ["activity", "date"]
    },
    {
      "content": "캘리포니아비치가서 튜브에 몸을 맡기고 유수풀 즐기기",
      "region": "gyeongju",
      "theme": ["activity", "date"]
    },
    {
      "content": "송대말등대에서 스노쿨링 하기",
      "region": "gyeongju",
      "theme": ["activity", "date"]
    },
    {
      "content": "월정교에서 아름다운 야경 즐기기",
      "region": "gyeongju",
      "theme": ["date", "hist", "healing"]
    },
    {
      "content": "석굴암에서 통일신라시대에 만들어진 불상 감상하며 경건함 느끼기",
      "region": "gyeongju",
      "theme": ["hist"]
    },
    {
      "content": "석굴암에서 타종 체험하기",
      "region": "gyeongju",
      "theme": ["hist"]
    },
    {
      "content": "실내 식물원 동궁원에서 신기한 식물들 구경하",
      "region": "gyeongju",
      "theme": ["date", "healing"]
    },
    {
      "content": "순두부골목에서 맛있는 순두부찌개 먹기",
      "region": "gyeongju",
      "theme": ["food"]
    },
    {
      "content": "버드파크에서 앵무새와 대화하고 먹이주기",
      "region": "gyeongju",
      "theme": ["date"]
    },
    {
      "content": "문무대왕릉에서 바다를 보며 힐링하기",
      "region": "gyeongju",
      "theme": ["date", "healing"]
    },
    {
      "content": "보문관광단지에서 백조보트 타기",
      "region": "gyeongju",
      "theme": ["date", "healing", "activity"]
    },
    {
      "content": "황리단길에서 황리단길의 명물 십원빵 먹기",
      "region": "gyeongju",
      "theme": ["food", "date"]
    },
    {
      "content": "황리단길에서 황리단길의 명물 쫀디기 먹기",
      "region": "gyeongju",
      "theme": ["food", "date"]
    },
    {
      "content": "황룡사 역사문화관에서 황룡사9층 목탑 모형보며 신라시대의 위대함 느끼기",
      "region": "gyeongju",
      "theme": ["hist", "date"]
    },
    {
      "content": "교촌마을에서 교촌치킨 시켜서 먹기",
      "region": "gyeongju",
      "theme": ["food", "hist"]
    },
    {
      "content": "교촌마을에서 한옥들과 돌담길들을 보며 산책하기",
      "region": "gyeongju",
      "theme": ["hist", "date", "healing"]
    },
    {
      "content": "빛누리정원에서 불빛야경 구경하기",
      "region": "gyeongju",
      "theme": ["date", "healing"]
    },
    {
      "content": "우리나라를 대표하는 불교사찰 불국사에서 석가탑과 다보탑 보기",
      "region": "gyeongju",
      "theme": ["hist"]
    },
    {
      "content": "불국사에서 템플스테이하며 마음을 다스리기",
      "region": "gyeongju",
      "theme": ["hist", "healing"]
    },
    {
      "content": "황리단길에서 한복입고 돌아다니기",
      "region": "gyeongju",
      "theme": ["hist", "date"]
    },
    {
      "content": "전촌항 용굴에서 인생샷 찍기",
      "region": "gyeongju",
      "theme": ["date", "healing"]
    },
    {
      "content": "추억의 달동네에서 옛날 교복입고 80년대 체험하기",
      "region": "gyeongju",
      "theme": ["date"]
    },
    {
      "content": "산림환경연구원 외나무다리에서 원수 만나기",
      "region": "gyeongju",
      "theme": ["date"]
    },
    {
      "content": "보문콜로세움에서 이탈리아에 있는 콜로세움 온 척 사진 찍기",
      "region": "gyeongju",
      "theme": ["date"]
    },
    {
      "content": "황룡원 중도타워를 배경으로해서 인생샷 찍기 ",
      "region": "gyeongju",
      "theme": ["date", "hist"]
    },
    {
      "content": "황성공원 꽃밭에서 꽃받침하고 사진찍기",
      "region": "gyeongju",
      "theme": ["date", "healing"]
    },
    {
      "content": "황성공원에서 푸릇푸릇한 식물들 보면서 산책하기",
      "region": "gyeongju",
      "theme": ["date", "healing"]
    },
    {
      "content": "바람의 언덕에서 풍차를 배경으로 하여 인생샷 찍기",
      "region": "gyeongju",
      "theme": ["date"]
    },
    {
      "content": "신라패러글라이딩에서 패러글라이딩하며 경주를 한눈에 내려다보기",
      "region": "gyeongju",
      "theme": ["activity", "date"]
    },
    {
      "content": "경주엑스포대공원에서 신라시대 미디어아트 구경하기",
      "region": "gyeongju",
      "theme": ["date", "hist"]
    },
    {
      "content": "경주엑스포대공원에서 웅장한 경주타워 밑으로 지나가면서 위에 사진찍기",
      "region": "gyeongju",
      "theme": ["date", "hist"]
    },
    {
      "content": "경주엑스포대공원 경주타워 전망대에서 경주를 한눈에 내려다 보기",
      "region": "gyeongju",
      "theme": ["date", "healing", "hist"]
    },
    {
      "content": "김유신장군모 벚꽃길에서 분홍색 옷 입고 벚꽃사진 찍기",
      "region": "gyeongju",
      "theme": ["date", "healing", "hist"]
    },
    {
      "content": "형상강 연등축제에서 연등불빛과 야경 구경하기",
      "region": "gyeongju",
      "theme": ["date", "healing"]
    },
    {
      "content": "금장대 나룻배 포토존에서 인생샷 찍기",
      "region": "gyeongju",
      "theme": ["date", "healing"]
    },
    {
      "content": "금장대 유채꽃길에서 노란 유채꽃들을 보며 산책하기",
      "region": "gyeongju",
      "theme": ["date", "healing"]
    },
    {
      "content": "황룡사 마루길에서 벚꽃을 보며 산책하기",
      "region": "gyeongju",
      "theme": ["date", "healing"]
    },
    {
      "content": "주전몽돌해변에서 바다를 바라보며 피크닉하기",
      "region": "gyeongju",
      "theme": ["date"]
    },
    {
      "content": "주전몽돌해변에서 동글동글 귀여운 돌 줍기",
      "region": "gyeongju",
      "theme": ["date"]
    },
    {
      "content": "보문정에서 연못을 가득채운 연꽃들을 배경으로 인생샷 찍기",
      "region": "gyeongju",
      "theme": ["date", "hist", "healing"]
    },
    {
      "content": "관성해수욕장에서 뉴턴 제 1법칙 관성의 법칙 공부하기",
      "region": "gyeongju",
      "theme": ["date"]
    },
    {
      "content": "명상바위에서 명상을 하며 마음의 안정찾기",
      "region": "gyeongju",
      "theme": ["healing", "date"]
    },
    {
      "content": "명상바위에서 뒤에 산들을 배경으로 인생샷 찍기",
      "region": "gyeongju",
      "theme": ["date", "healing"]
    },
    {
      "content": "신라천년서고에서 책을 읽으며 마음의 양식쌓기",
      "region": "gyeongju",
      "theme": ["date", "hist", "healing"]
    },
    {
      "content": "도리마을에서 도리도리하면서 영상 찍기",
      "region": "gyeongju",
      "theme": ["date"]
    },
    {
      "content": "도리마을 은행나무 숲에서 노란색으로 물든 은행나무를 배경으로 인생샷 찍기",
      "region": "gyeongju",
      "theme": ["date", "healing"]
    },
    {
      "content": "도봉서당 작약꽃밭에서 꽃들사이에서 인생샷 찍기",
      "region": "gyeongju",
      "theme": ["date", "healing"]
    },
    {
      "content": "국민힐링파크에서 카누체험하면서 오리들에게 먹이주기",
      "region": "gyeongju",
      "theme": ["date", "activity"]
    },
    {
      "content": "경주루지월드에서 루지타면서 스피드를 즐기기",
      "region": "gyeongju",
      "theme": ["date", "activity"]
    },
    {
      "content": "보문단지에서 스쿠터빌려서 경주를 둘러보기",
      "region": "gyeongju",
      "theme": ["date", "activity"]
    }
  ];
  WriteBatch batch = FirebaseFirestore.instance.batch();

  for (var item in notifications) {
    // Create a new document reference
    DocumentReference ref =
        FirebaseFirestore.instance.collection('recommend').doc();
    // Add this item to the batch
    batch.set(ref, item);
  }

  // Commit the batch
  await batch.commit().then((value) {
    print('Batch write completed successfully.');
  }).catchError((error) {
    print('Error in batch write: $error');
  });
}
