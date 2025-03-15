![image](https://github.com/user-attachments/assets/e0ff26c4-c7e9-4fd3-a79b-03cb14e2f399)

# Fitween

> AI 모션인식과 게임 요소를 활용한 운동 동기부여 어플리케이션

<div align="right">홈페이지 링크 :<a target="_blank" href="https://fitween.notion.site/Fitween-8bef341ef8904eed894c79b259903675?pvs=4"><img align="right" width="30px" height="30px" src="https://github.com/user-attachments/assets/76921e8a-c31c-4024-9e8d-99349083a9b9" alt="fitween-logo" /></a></div>

<br />

<div align="right">다운로드 링크 :<a target="_blank" href="https://apps.apple.com/kr/app/fitween/id1671114122?l=ko-KR"><img align="right" width="30px" height="30px" src="https://github.com/user-attachments/assets/f434ef80-3e04-45c2-a7ee-7464d0b15c6a" alt="appstore-icon" /></a></div>

<br />

## 지원 및 업데이트

- 📩 이메일: &nbsp; fitween.corp@gmail.com
- 🛠️ 고객지원: &nbsp; <a target="_blank" href="https://fitween.notion.site/29ab2908321e4e499cb36814aac210cd?pvs=4"><img width="20px" height="20px" src="https://github.com/user-attachments/assets/4db93049-f5f0-4fc8-bda1-77685501b60c" alt="support"></a>
- 📜 릴리즈 노트: &nbsp; <a target="_blank" href="https://fitween.notion.site/aa14492c494943ad803d15d30cb0b34b?pvs=4"><img width="20px" height="20px" src="https://github.com/user-attachments/assets/4db93049-f5f0-4fc8-bda1-77685501b60c" alt="release-note"></a>
  > 최신버전 - ver. 2.0.3 (20231220)

<br />

## 기술스택

<span>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=ffffff" alt="dart">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=ffffff" alt="flutter">
  <img src="https://img.shields.io/badge/Firebase-DD2C00?style=for-the-badge&logo=firebase&logoColor=ffffff" alt="firebase">
  <img src="https://img.shields.io/badge/TensorFlow-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=ffffff" alt="tensorflow">
</span>

<br />

## 화면

<img align="right" width="200px" src="https://github.com/user-attachments/assets/2edca7d8-9932-44c8-ae02-b218445006d2" alt="main">

### 메인화면

> 사용자의 일일 운동 기록을 한눈에 확인할 수 있는 홈 화면

- 상단 3색 구슬

  - 선택된 날짜 당일에 걸은 걸음, 오른 높이, 들은 무게 표시
  - Circular Carousel 위젯으로 구현하여 사용자 제스쳐에 따라 부드럽게 모션

    > - 구현 방법: &nbsp; <a target="_blank" href="https://seungjoonh.tistory.com/entry/flutter-circular-carousel"><img width="20px" height="20px" src="https://github.com/user-attachments/assets/497b058d-7cfb-4bfc-8456-3aa541858898" alt="tistory-circular-carousel"> [Flutter] 순환 캐러셀 (Circular Carousel) 위젯 만들기</a>

- 기록 카드

  - 주력(週曆)에 특정 날짜 선택 가능
  - 날짜별 목표 달성 여부 표시
  - 좌우로 스크롤 하여 과거 날짜 표시 가능
  - `오늘 보기` 버튼을 통해 오늘 날짜 바로 선택 가능
  - 카드를 탭하여 기록 화면으로 이동 가능

- 랭킹 카드

  - 일간/주간/월간 친구 사이 랭킹 및 데이터 표시
  - 랭킹 초기화까지 남은 시간 표시
  - 카드를 탭하여 랭킹 화면으로 이동 가능

<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/63cd075e-5cf8-4a32-a370-8556be062970" alt="record">

### 기록화면

> 날짜별 활동 기록을 상세히 확인할 수 있는 화면

<br />

- 포인트 칩

  - 잔여 포인트(FPoint) 표시
  - 칩 탭하여 포인트 화면으로 이동 가능

- 달력 카드

  - 달력에 특정 날짜 선택 가능
  - 좌우로 스크롤 하여 과거 날짜 표시 가능
  - 날짜별 목표 달성 여부 표시

- 하단 카드

  - 선택된 날짜의 활동 상세 정보 표시
  - 해당 날짜의 목표 달성 여부 표시

<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/64457333-daac-4166-92e6-64632db3d33e" alt="friend">

### 친구화면

> 사용자가 추가한 친구 목록을 관리하는 화면

<br />

- 돋보기 버튼

  - 버튼 탭 시 친구 검색 가능

- 친구 카드

  - 친구 목록 확인 가능
  - 펜 버튼 탭 시 친구 수정 및 삭제 가능
  - 친구 프로필 사진 탭 시 해당 뱃지 정보 확인 가능
  - 친구 버튼 탭 시 친구의 기록 내역 확인 가능


<br />
<br />
<br />
<br />
<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/91313df6-b36a-4e10-9e8e-993b2cb7ef44" alt="content">

### 컨텐츠화면

> 서비스 내 다양한 운동 관련 컨텐츠를 모아둔 화면

<br />

- 모험 카드

  - 카드 탭 시 모험화면으로 이동 가능

- 챌린지 카드

  - 카드 탭 시 챌린지화면으로 이동 가능

- 웨이트 카드

  - 카드 탭 시 웨이트화면으로 이동 가능

<br />
<br />
<br />
<br />
<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/3f8775fb-7cd6-4dca-bb6a-c65f473d586f" alt="adventure-height">
<img align="right" width="200px" src="https://github.com/user-attachments/assets/98a4b7f9-cb2f-4f06-88eb-c322d58f950a" alt="adventure-distance">

### 모험화면

> 사용자의 운동 데이터를 기반으로 진행되는 랭킹 및 여정 시각화 화면

<br />

- 섬 (Isometric Style)

  - 탭 시 관련 섬 정보화면으로 이동 가능

- 상단 구름에 둘러싸인 흐릿한 섬

  - 아직 도달하지 못한 목표 지점
  - 궁금증을 유발하여 다음 목표 달성을 위한 동기부여 제공
  - 현재 목표 달성 시 해금

- 좌측 리본 위젯

  - 거리/높이/무게 각 카테고리 탭 시 해당 바다로 이동

- 우측 뱃지 아이콘

  - 친구와 달성 상황 공유

<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/5c64f816-4ee9-4012-b3e8-90b920ed21b3" alt="adventure-height">
<img align="right" width="200px" src="https://github.com/user-attachments/assets/6c5f2381-a1a3-411a-975d-1557a1d6343d" alt="adventure-distance">

### 섬 정보화면

> 사용자의 현재까지 성취한 그리고 현재 진행중인 목표에 대한 상세 정보를 제공하는 화면

<br />

- 섬 이미지

  - 확대된 섬 이미지 (`Hero` 위젯 적용) 제공

- 하단 텍스트

  - 해당 섬이 실제 세계의 특정 장소 또는 랜드마크와 거리/높이/무게를 비교하여 사용자의 데이터를 직관적으로 이해할 수 있도록 설명
  - 해당 장소 및 랜드마크의 간단한 설명 제공
  - 섬의 레벨 및 난이도 정보 출력

- 하단 진행도 바

  - 다음 섬까지의 진행도 표시

- 상단 보상 아이콘

  - 목표 달성 시 뱃지 또는 포인트 아이템 획득 가능

<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/a1eab6e4-f1fc-4396-a38e-35bc962ca32d" alt="challenge-height">
<img align="right" width="200px" src="https://github.com/user-attachments/assets/e91bb367-4f35-4ec7-95db-f383a569305f" alt="challenge-distance">

### 챌린지화면

> 사용자가 도전할 수 있는 운동 챌린지를 탐색하고 관리할 수 있는 화면

<br />

- 상단 돋보기 버튼

  - 탭 시 파티 검색화면으로 이동 가능

-  상단 원형 위젯

-  현재 진행 중인 파티 썸네일 표시
-  탭 시 해당 파티화면으로 이동 가능

-  하단 탭 및 카드 목록

- 현재 진행 가능한 챌린지 목록 표시
- 탭 시 해당 챌린지 상세화면으로 이동 가능

<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/d7ecf2ea-093f-4396-9920-1bad78828e7e" alt="challenge-detail-height">
<img align="right" width="200px" src="https://github.com/user-attachments/assets/9ac133a4-c8a7-4fe4-874f-ebb5a6bd0f16" alt="challenge-detail-distance">

### 챌린지 상세화면

> 선택한 챌린지의 상세 정보를 확인하고, 파티를 생성하거나 참가할 수 있는 화면

<br />

- 챌린지 정보 출력

  - 챌린지 이미지, 제목, 설명(스토리)

- 하단 버튼

  - 현재 진행 중인 파티가 있을 시 "내 파티 바로가기" 버튼 활성화
  - 현재 진행 중인 파티가 없을 시 "파티 검색하기", "파티 생성하기" 버튼 활성화
  - "파티 검색하기" 버튼 탭 시 파티 검색화면으로 이동 가능
  - "파티 생성하기" 버튼 탭 시 파티 생성화면으로 이동 가능

<br />
<br />
<br />
<br />
<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/c5d64a8d-004c-4153-8cfc-461da23f3e69" alt="party-top">
<img align="right" width="200px" src="https://github.com/user-attachments/assets/c0e2dfc4-6d61-4d87-a101-e79b62169353" alt="party-bottom">

### 파티화면

> 사용자가 참여 중인 챌린지 파티의 진행 상황을 확인하고, 멤버를 관리할 수 있는 화면

<br />

- 상단 멤버 버튼

  - 파티 참여 중인 멤버 관리 가능

- 조회수 위젯

  - 해당 파티의 조회수 표시

- 정보 카드

  - 해당 파티의 정보 표시
  - 연필 아이콘 버튼 탭 시 파티 제목 변경 가능
  - 최대인원, 마감기한, 난이도, 종류 등 표시

- 진행도 카드

  - 멤버 전체 합산 데이터에 따른 목표 달성도 표시
  - 멤버 목록 표시
  - 멤버 탭 시 주간 운동량 통계 표시
  - 참여 코드 버튼 탭 시 해당 코드 복사 가능

- 하단 포기하기 버튼

  - 파티장이 탭 시 파티 삭제 가능
  - 파티원이 탭 시 파티 탈퇴 가능

<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/c85d0ab2-fb76-4cbb-b6c4-2f27094575fd" alt="party-search">

### 파티 검색화면

> 사용자가 참여할 수 있는 챌린지 파티를 검색하고 필터링하여 탐색할 수 있는 화면

<br />

- 상단 텍스트 필드

  - 검색어 입력 가능

- 체크박스 버튼 3개

  - 파티 검색 필터

- 파티 카드 목록

  - 검색된 파티 목록 출력
  - 파티 카드 탭 시 해당 파티화면으로 이동 가능

<br />
<br />
<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/f46b14a6-1412-4b72-b723-b0003a970175" alt="party-create-bottom">
<img align="right" width="200px" src="https://github.com/user-attachments/assets/5ca0cd7d-e69b-4e9c-8e3a-3abcdd1d4857" alt="party-create-top">

### 파티 생성화면

> 사용자가 새로운 파티를 생성하고, 챌린지 목표 및 설정을 지정할 수 있는 화면

<br />

- 상단 텍스트 필드

  - 생성할 파티 이름 설정
  - 기본값: 챌린지 이름

- 난이도 버튼

  - 해당 파티 난이도 설정 가능

-  파티 설명 텍스트 섹션

- 난이도에 따른 스토리 일부 변경

- 파티 정보 섹션

  - 난이도에 따른 목표, 최대인원, 기간, 획득 가능 포인트 표시

- 파티 생성하기 버튼

  - 탭 시 파티 생성 가능


<br />
<br />
<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/c28fced5-9196-4892-a098-b10d5681d82d" alt="weight">

### 웨이트화면

> 사용자가 다양한 웨이트 운동을 선택하고 기록할 수 있는 화면

- 웨이트운동 선택 가능

  - 사용자가 수행할 웨이트 운동을 선택할 수 있음
  - 현재 스쿼트만 선택 가능


<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/fefc9c00-bbd3-4cd3-90c0-ea0d222d97b0" alt="squat">

### 스쿼트화면

> 🚧 현재 사용할 수 없는 기능입니다.
> 해당 기능은 준비 중이며, 추후 업데이트를 통해 제공될 예정입니다.

> 스쿼트 운동을 수행하고 기록할 수 있는 화면

- 스쿼트 운동 기록 가능
  - 카메라를 거치한 채로 스쿼트 수행 시 개수 측정
  - 수행 완료 시 해당 운동 데이터 누적 가능

  > - 구현 방법: &nbsp; <a target="_blank" href="https://aluminum-whimsey-4dd.notion.site/MoveNet-70575dbd22ef42048f487da42336727f"><img width="20px" height="20px" src="https://github.com/user-attachments/assets/62839865-50ea-4622-8173-10b017dcfc62"> MoveNet</a>

<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/1703f056-e54c-4364-959b-9db20dee8008" alt="seemore">

### 더보기화면

> 사용자의 포인트, 뱃지, 인벤토리 등의 부가 정보를 확인하고, 설정 및 알림 화면으로 이동할 수 있는 화면

<br />

- 상단 앱 바 `action` 버튼

  - 종 아이콘 버튼 탭 시 알림화면으로 이동 가능
  - 설정 버튼 탭 시 설정화면으로 이동 가능

- 포인트 카드

  - 잔여 포인트 표시
  - 탭 시 포인트화면으로 이동 가능

- 뱃지 카드

  - 메인 뱃지 및 최근 획득 뱃지 표시
  - 탭 시 뱃지화면으로 이동 가능

- 인벤토리 카드

  - 보유 중인 일부 아이템 표시
  - 탭 시 인벤토리페이지로 이동 가능


<br />
<br />
<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/6e9b7c83-9d1d-40e9-847c-d19aa92ce281" alt="notification">

### 알림화면

> 사용자에게 전달된 다양한 알림을 확인할 수 있는 화면

<br />

- 알림 확인 가능

  - 챌린지 신청 알림, 팔로우 신청 알림 등

<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/0c1fe32c-c1d8-48ef-b27a-4417329381ac" alt="point">

### 포인트화면

> 사용자가 보유한 포인트(FPoint)를 확인하고, 획득 및 사용 내역을 조회할 수 있는 화면

<br />

- 잔여 포인트 표시
- 포인트 획득 및 소모처 확인 가능

<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/2a8e0716-fa33-4358-b0f2-6bf5d3e7dbb0" alt="badge-info">
<img align="right" width="200px" src="https://github.com/user-attachments/assets/3d57e27e-0064-4bed-be33-d64c06473ddf" alt="badge">

### 뱃지화면

> 사용자가 획득한 뱃지를 확인하고, 대표 뱃지를 설정할 수 있는 화면

<br />

- 보유 뱃지 목록 표시

  - 뱃지 이름, 보유 개수, 최근 획득일자 표시
  - 탭 시 뱃지 상세 정보 다이얼로그 표시
  - 롱프레스 시 메인 뱃지 변경 가능


<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/38c1be44-b1e8-4df9-8463-5b09d8566f34" alt="inventory-item">
<img align="right" width="200px" src="https://github.com/user-attachments/assets/fc226e1f-8bc0-457c-87d2-5cb871f1616a" alt="inventory">

### 인벤토리화면

> 사용자가 보유한 아이템을 관리하고, 상세 정보를 확인하며 사용할 수 있는 화면

<br />

- 보유 아이템 목록 표시

  - 아이템 이미지, 보유 개수 표시
  - 탭 시 아이템 상세 정보 다이얼로그 표시
  - 사용 버튼 탭 시 아이템 사용 가능


<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />


<img align="right" width="200px" src="https://github.com/user-attachments/assets/ba7a74c3-615c-440e-8f2f-3ee262bf9b56" alt="settings">

### 설정화면

> 사용자가 앱의 환경 설정을 조정하고, 계정 및 개인 정보를 관리할 수 있는 화면

<br />

- 일반 설정 버튼 탭 시 일반 설정화면으로 이동 가능
- 계정 관리 버튼 탭 시 계정 관리화면으로 이동 가능
- 내 정보 관리 버튼 탭 시 내 정보 관리화면으로 이동 가능
- 앱 정보 버튼 탭 시 앱 정보화면 이동 가능


<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />


<img align="right" width="200px" src="https://github.com/user-attachments/assets/0d9ed32c-8392-4816-af38-9f0f10e7a1d5" alt="general-settings-english">
<img align="right" width="200px" src="https://github.com/user-attachments/assets/097f9827-f10a-49a6-b147-9f22c209657e" alt="general-settings-dark">
<img align="right" width="200px" src="https://github.com/user-attachments/assets/e398901d-3636-4d95-acf3-a56d84a58401" alt="general-settings-default">


### 일반 설정화면

> 사용자가 앱의 기본 환경을 설정할 수 있는 화면

<br />

- 디스플레이 설정

  - 시스템/라이트/다크 모드 선택 가능

- 언어 설정

  - 시스템/영어/한국어 선택 가능

<br />
<br />
<br />
<br />
<br />
<br />

#### 다크모드 및 영어 적용

<img align="left" width="200px" src="https://github.com/user-attachments/assets/773e10d0-5191-4645-a44e-da60026ec710" alt="dark-seemore">
<img align="left" width="200px" src="https://github.com/user-attachments/assets/a868f3e3-94b2-4950-adde-cee8047d4601" alt="dark-adventrue">
<img align="right" width="200px" src="https://github.com/user-attachments/assets/e57f5516-5ae8-492a-b932-683df5d3e433" alt="english-seemore">
<img align="right" width="200px" src="https://github.com/user-attachments/assets/e1b31d6f-95fe-44e4-85fc-30dba25df736" alt="english-island-detail">

<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/0673e209-c00e-4e37-9b8f-6114b73b1cd5" alt="account-settings">

### 계정 관리화면

> 사용자가 로그인 정보 및 계정 설정을 관리할 수 있는 화면

<br />

- 사용자 정보 표시

  - 프로필 이미지, 사용자 이름, 이메일 표시

- 자동 로그인 체크박스 버튼

  - 탭 시 자동 로그인 여부 설정 가능

- 하단 로그아웃 버튼

  - 로그아웃 가능

<br />
<br />
<br />
<br />
<br />
<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/3899e870-cc88-438d-b69d-fbcaa0bb747c" alt="my-info-settings-editing">
<img align="right" width="200px" src="https://github.com/user-attachments/assets/c521f3df-82ce-48f2-aa04-eb5714f9ec6e" alt="my-info-settings">

### 내 정보 관리화면

> 사용자가 자신의 신체 정보와 목표를 설정 및 수정할 수 있는 화면

<br />

- 사용자 정보 표시

  - 신장, 체중, 목표 표시
  - 각 섹션 연필 아이콘 버튼 탭 시 수정 가능

<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />

#### 목표 설정화면 플로우

<span>
<img width="200px" height="400px" src="https://github.com/user-attachments/assets/85bf028e-610f-4b02-843c-ecc8ff39585c" alt="goal-edit-1">
<img width="200px" height="400px" src="https://github.com/user-attachments/assets/a656e09f-809e-4a79-b4cf-1193f2695b71" alt="goal-edit-2">
<img width="200px" height="400px" src="https://github.com/user-attachments/assets/884ba0c8-89a7-4951-be98-610cfff392ff" alt="goal-edit-3">
<img width="200px" height="400px" src="https://github.com/user-attachments/assets/d9313cf5-8bca-470a-833b-e2c788f184a8" alt="goal-edit-4">
</span>

<br />

<span>
<img width="200px" height="400px" src="https://github.com/user-attachments/assets/26fbc7f4-f87d-493b-a223-4c5f9c9c1820" alt="goal-edit-5">
<img width="200px" height="400px" src="https://github.com/user-attachments/assets/b4b71ade-43ee-45e2-be74-ccb67a07633a" alt="goal-edit-6">
<img width="200px" height="400px" src="https://github.com/user-attachments/assets/ae59748b-776f-4e23-a9d3-25e4a3e56d40" alt="goal-edit-7">
<img width="200px" height="400px" src="https://github.com/user-attachments/assets/6d61b182-6956-4cbf-b4e1-da44deafee65" alt="goal-edit-8">
</span>


<br />
<br />
<br />
<br />

<img align="right" width="200px" src="https://github.com/user-attachments/assets/85176546-0ae9-49b2-a5bc-b7ed790eb3be" alt="app-info">

### 앱 정보 화면

> 앱의 버전 및 정책을 확인하고, 오류 제보 및 개선 요청을 할 수 있는 화면

<br />

- 어플리케이션 정보 확인 가능

  - 회사 정보 - 앱을 개발한 회사 및 연락처 정보
  - 오픈소스 라이선스 - 사용된 라이브러리 및 오픈소스 소프트웨어 목록
  - 이용약관 - 서비스 이용 규정
  - 개인정보 처리방침 - 수집된 개인 정보의 처리 방식
  - 버전 정보 - 현재 설치된 앱의 버전 확인
  - 고객 지원 정보 - 문의 및 지원 채널 안내

- 오류 제보 / 개선 요청 버튼

  - 리포트화면으로 이동 가능

<br />
<br />
<br />
<br />

### 리포트화면

> 사용자가 앱 사용 중 발견한 오류를 제보하거나, 기능 개선을 요청할 수 있는 화면

<br />

- 오류 제보 및 개선 요청 가능

- 카테고리 선택 가능

  - 디자인 결함
  - 계정정보 연동 오류
  - 컨텐츠
  - 기타 오류
  - 문의

- 나의 문의 내역 확인 가능

  - 목록 표시
  - 상세 표시

<br />

<img width="200px" src="https://github.com/user-attachments/assets/7d244b9f-6a35-421a-aab9-7923e3bc987c" alt="report-1">
<img width="200px" src="https://github.com/user-attachments/assets/03b95044-9ef0-49c5-9e34-85a1e4c6440c" alt="report-2">
<img width="200px" src="https://github.com/user-attachments/assets/0e2c6470-c8d9-4da8-8663-6063521a12ee" alt="report-3">
<img width="200px" src="https://github.com/user-attachments/assets/e3ef269d-a656-42e5-b65d-e7a534b30534" alt="report-4">
