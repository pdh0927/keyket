## 프로젝트 정보



- **작업 기간** : 23.06 - 23.09 (약 3개월)
- **인원** : 4명
- **내 역할(기여도)** : 기획(70%), 앱 개발(95%)
- **프로젝트 목적**
    1. 단조로운 여행 패턴 개선
    2. 광고가 아닌 나에게 꼭 맞는 여행 정보 제공
    3. 여행지 편향 현상 개선
- **프로젝트 내용**
    - 지역별 먹거리, 놀거리, 볼거리를 버킷리스트 항목 형태로 추천
    - 버킷리스트를 가족, 친구, 연인을 초대하여 공유로 사용
    - 추천에 없는데 넣고 싶은 항목은 커스텀으로 추가
    - 지역별 날씨 및 여행 항목 추천
    - 공유 버킷리스트에 사용할 프로필 이미지 및 닉네임 수정
- 대표 사용 기술 : `Riverpod`, `Shimmer`, `CachedNetworkImage`, `WriteBatch`, `FirebaseAuth`, `OAuthToken`

---

## 키킷



> 여행에 새로운 가치를 더해줄 여행 공유 버킷리스트  

✋ 매번 똑같은 패턴의 지겨운 여행은 그만  
👨‍👩‍👧‍👦 가족, 친구, 애인과 공유하여 사용하는 버킷리스트  
🎢 지역, 테마별로 특색 있는 버킷리스트 항목 추천까지  

[시연 영상](https://youtu.be/_U4WaBBXDcw)

---

## 배포 링크



- IOS : [키킷 iOS 앱](https://apps.apple.com/kr/app/%ED%82%A4%ED%82%B7/id6463154564)
- AOS : [키킷 AOS 앱](https://play.google.com/store/apps/details?id=com.dhapp.keyket)

---

## 주요 기능 및 트러블 슈팅



### 추천 버킷리스트 항목

<img src="https://firebasestorage.googleapis.com/v0/b/meat-dictionary.appspot.com/o/git-image%2Fkeyket%2F1.png?alt=media&token=805ed2e7-aea5-4a75-a38d-480e48f0f534" alt="추천 버킷리스트 항목" width="300"/>

- **기능 설명**
    - 먹거리, 놀거리, 볼거리를 버킷리스트 항목 형태로 추천
    - 지역 및 테마별로 필터링 기능을 제공하여 개인화된 추천 경험 제공
    - 사용자가 추천 항목을 선택하여 자신만의 맞춤형 버킷리스트를 쉽게 구성 가능
- **구현 기술**
    - 대용량 사진 데이터 처리를 위해 `Pagination`을 구현하고, 스크롤 동작에 따라 데이터가 동적으로 추가되는 기능을 설계
    - 불러온 데이터를 `Riverpod` 기반 상태 관리와 캐싱 최적화를 통해 네트워크 요청을 최소화
    - `Shimmer` 효과와 `CachedNetworkImage`를 활용해 이미지 로딩 중 사용자 경험을 개선하고, 네트워크 트래픽을 최적화

---

### 개인/공유 버킷리스트

<img src="https://firebasestorage.googleapis.com/v0/b/meat-dictionary.appspot.com/o/git-image%2Fkeyket%2F2.png?alt=media&token=72109606-6170-4fd8-b001-fcc15e683efc" alt="개인/공유 버킷리스트" width="300"/>

- **기능 설명**
    - 사용자가 선택한 버킷리스트의 세부 항목을 확인하고 수정(완료, 미완료)
    - 직접 입력 또는 추천을 통해 새로운 커스텀 항목을 추가
    - 초대 코드를 통한 사용자 추가
    - 버킷리스트 정보 변경(배경 이미지, 이름 등)하여 특색있는 버킷리스트 구성
- **구현 기술**
    - Firestore `WriteBatch`를 사용해 여러 작업(추가, 수정, 삭제)을 한 번에 처리하여 네트워크 호출 횟수를 최소화하고, **데이터 일관성을 보장**
    - 이미지 업로드 전, 이미지 압축(`compressImage`)을 통해 데이터 크기 최적화

---

### 다양한 기능의 홈화면

<img src="https://firebasestorage.googleapis.com/v0/b/meat-dictionary.appspot.com/o/git-image%2Fkeyket%2F3.png?alt=media&token=6787df17-6b87-499e-9c76-a092852e21ed" alt="다양한 기능의 홈화면" width="300"/>

- **기능 설명**
    - 랜덤으로 지역을 선택하여 해당 지역의 날씨 정보와 추천 지역 이미지를 함께 제공
    - 사용자가 자주 사용하는 버킷리스트를 고정된 상태로 표시하여 빠르게 접근할 수 있도록 지원
    - 배너 광고를 통해 사용자에게 부가적인 정보 제공 및 광고 수익 창출
    - 예시 버킷리스트를 제공하여 사용자가 앱의 활용 방법을 직관적으로 이해할 수 있도록 지원

---

### 로그인 화면

<img src="https://firebasestorage.googleapis.com/v0/b/meat-dictionary.appspot.com/o/git-image%2Fkeyket%2F4.png?alt=media&token=33dee68e-99aa-4740-bd4f-0ba4060e831c" alt="로그인 화면" width="300"/>

- **기능 설명**
    - 카카오톡, 구글, 애플 간편 로그인 제공
    - 로그아웃하지 않았다면 자동 로그인 기능 제공
- **구현 기술**
    - `FirebaseAuth`를 통한 카카오톡, 구글, 애플 간편 로그인 제공
    - `OAuthToken`을 이용한 자동 로그인 구현

---

### 내 프로필 화면

<img src="https://firebasestorage.googleapis.com/v0/b/meat-dictionary.appspot.com/o/git-image%2Fkeyket%2F5.png?alt=media&token=87a71d27-380d-449c-bb05-dcd2d3ec697c" alt="내 프로필 화면" width="300"/>

- **기능 설명**
    - 사용자의 프로필 정보를 확인하고 관리할 수 있는 기능 제공
    - 사용자가 로그인된 상태에서 개인 버킷리스트와 알림 정보를 확인
    - 사용자의 계정 로그아웃 기능 지원, 계정 제공자(Google, Apple, Kakao)에 따라 적절히 처리
- **구현 기술**
    - `FirebaseAuth`를 통한 로그인 상태 확인 및 계정 정보 관리

---

### 기능 온보딩

<img src="https://firebasestorage.googleapis.com/v0/b/meat-dictionary.appspot.com/o/git-image%2Fkeyket%2F6.png?alt=media&token=c514a3a8-ce8e-47c5-a73b-73109bd4cc95" alt="기능 온보딩" width="300"/>

- **기능 설명**
    - 유저들이 기능을 쉽게 사용할 수 있도록 기능 설명서 제공

---


