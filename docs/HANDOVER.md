# Seeya 프로젝트 인계서

---

## 1. 프로젝트 개요

포토부스 이벤트 기반 사진 촬영/합성/출력 앱.
이벤트 탐색(지도) → 프레임 선택 → 카메라 4컷 촬영 → 이미지 합성 → 출력 요청 흐름.

| 항목 | 값 |
|------|-----|
| 패키지명 | `com.cherryish.seeya` |
| 버전 | 2.2.8+24 |
| FVM Flutter | **3.35.1** (`.fvmrc` 참고) |
| Dart SDK | >=3.4.1 |
| 상태관리 | GetX |
| API 서버 | `https://api-v2.seeya-printer.com` |
| S3 | `https://seeya-jp-bucket.s3.ap-northeast-1.amazonaws.com/` |
| 도메인 | `https://www.seeya-printer.com` |
| 다국어 | Ko / Ja / En (GetX Translations, `lib/languages.dart`) |

---

## 2. 환경 설정

- **FVM** 사용. `.fvmrc`에 Flutter 버전 고정 (`3.35.1`)
- 코드 생성: `flutter pub run build_runner build --delete-conflicting-outputs` (모델 `*.g.dart` 파일)
- Android NDK: `27.0.12077973` (build.gradle에 고정)
- Android Java: `VERSION_21`
- Android minSdk: `30`
- iOS Deployment Target: `16.0` (Podfile: `14.0`)
- iOS Development Team: `BDS7SM7KBL`

### 서명 (Android)

```
keystore 파일: android/keystore/seeya_keystore.jks (별도 전달)
비밀번호 파일: android/keystore/keystore.password (별도 전달)
key alias: seeya_keystore
```

build.gradle에서 password 파일을 읽어 서명하는 방식. keystore 디렉토리 통째로 전달받아 배치하면 됨.

---

## 3. 프로젝트 구조

```
lib/
├── main.dart                    # 진입점. 초기화 순서 중요 (아래 참고)
├── languages.dart               # 다국어 번역 정의
├── firebase_options.dart        # Firebase 설정 (자동 생성)
│
├── binding/                     # GetX 바인딩 (라우트별 DI)
├── controller/                  # GetX 컨트롤러 (비즈니스 로직)
│
├── core/
│   ├── config/
│   │   ├── app_router.dart      # 라우트 정의 (22개)
│   │   ├── app_secret.dart      # API 키, Base URL 등 (별도 전달)
│   │   ├── app_colors.dart      # 컬러 팔레트
│   │   ├── app_themes.dart      # 테마 (폰트: DungGeunMo)
│   │   ├── app_prefs_keys.dart  # SharedPreferences 키 상수
│   │   └── seeya_frame_configs.dart  # 프레임 좌표 (1920x2880, 필터 786x1064)
│   │
│   ├── services/
│   │   ├── dio_service.dart         # Dio 설정 + 인터셉터
│   │   ├── user_service.dart        # 유저 상태 (GetxService, 앱 전역)
│   │   ├── preference_service.dart  # SharedPreferences 래퍼
│   │   └── notification_service.dart # FCM + 로컬 알림
│   │
│   ├── data/
│   │   ├── enum/           # SocialLoginType, EventStatus 등
│   │   ├── model/          # API 모델 (auth/, event/, print/, file/, common/)
│   │   └── repository/     # API 호출 (auth, event, print, file, common)
│   │
│   ├── utils/              # 이미지 합성, 포맷, 위치, 파일 등 유틸
│   └── cache/              # 이미지 캐시 매니저 (14일, 500개)
│
├── data/model/              # UI 전용 모델 (v1 호환, 레거시)
│
└── view/
    ├── common/              # 공용 위젯 (SeeyaCachedImage, LoadingOverlay 등)
    ├── dialog/              # 다이얼로그, 바텀시트
    ├── root/                # 메인 탭 (홈/지도/마이페이지)
    ├── camera/              # 카메라 촬영
    ├── decorate_frame/      # 프레임 합성
    ├── event_detail/        # 이벤트 상세
    └── ...                  # login, search, print_history, payment 등
```

### lib/data/model/ (v1 레거시) 참고

`DecorateFrameController`에서 v2 API 모델(`Event`, `EditorFrame`)을 v1 UI 모델로 변환하여 사용하는 부분이 있음. 점진적 마이그레이션 대상.

---

## 4. 아키텍처

### GetX MVC

```
View (Obx) → Controller (.obs 반응형) → Repository (Dio 호출) → DioService
                        ↕
                  Service (앱 전역 상태)
```

- **Binding**: 라우트 진입 시 `Get.put()` / `Get.lazyPut()`으로 Controller 등록
- **Service**: `GetxService` 상속. 앱 수명주기 동안 유지 (`UserService`, `DioService`)
- **Model**: `@JsonSerializable(fieldRename: FieldRename.snake)` 사용

### 초기화 순서 (main.dart)

순서 의존성이 있으므로 변경 시 주의:

```
1.  이미지 캐시 설정 (500개, 150MB)
2.  화면 방향 고정 (세로)
3.  BackButtonInterceptor (로딩 오버레이 시 뒤로가기 차단)
4.  Firebase 초기화 → Crashlytics/Analytics (debug 모드 비활성화)
5.  로컬 알림 초기화 + FCM 핸들러 등록
6.  Kakao SDK 초기화
7.  Naver Login SDK 초기화
8.  UserService 초기화
9.  libphonenumber 초기화
10. SharedPreferences 초기화 ← DioService보다 먼저
11. DioService 초기화 (Preferences에서 토큰 읽음)
12. 임시 파일 정리
13. runApp()
```

스플래시 화면(`CustomSplashScreen`)에서 FCM 토큰 획득 및 저장된 액세스 토큰 유효성 검증 후 `/root`로 이동. iOS에서 APNS 토큰 콜백 타이밍 이슈로 1초 딜레이 처리 있음(주석 참고).

---

## 5. 주요 기능 흐름

### 인증

```
소셜 로그인 (Google / Apple / Kakao / Naver)
→ LoginComponentController.signInWith*()
→ AuthRepository.login() → 토큰 수신 → SharedPreferences 저장
→ 전화번호 미인증 시 → /phone_verification (Firebase Phone Auth + ReCAPTCHA)
→ /enter_user_info → /sign_up_finish → /root
```

토큰: `SharedPreferences`에 `user_access_token` 키. Dio 인터셉터가 `Bearer` 헤더 자동 추가.

### 카메라 → 출력

```
이벤트 & 프레임 선택 → /camera (4컷 촬영)
→ 각 촬영 후 /image_crop → /decorate_frame (합성)
→ 최종 이미지: 1920x2880px, 필터 영역 786x1064px
→ 프레임 타입별 좌표: seeya_frame_configs.dart (type_a~e)
→ /payment → PrintRepository.createPrintQueue()
```

이미지 처리: EXIF 회전 보정 → 크롭 → 리사이즈 → 필터 이미지 오버레이 (`ImageUtils`)

### 지도

- `MapTabController`: Google Maps 마커 표시 + 15m 반경 클러스터링
- 커스텀 마커 이미지: `MarkerIconCache`로 캐싱
- Naver Maps → Google Maps 마이그레이션 완료 (`GOOGLE_MAPS_MIGRATION.md` 참고)

### 딥링크

```
스킴: seeya://deeplink/event/{eventId}
웹:  https://www.seeya-printer.com/deeplink/event/{eventId}
처리: RootController.initDeepLink() → app_links 패키지
```

- Android: `AndroidManifest.xml` intent filter (autoVerify)
- iOS: `AppDelegate.swift`에서 직접 핸들링 (`FlutterDeepLinkingEnabled = false`)
- iOS Associated Domains: `applinks:www.seeya-printer.com` (`Runner.entitlements`)

### 푸시 알림

- FCM 토큰 → SharedPreferences 저장
- 포그라운드: `LocalNotificationService.createNotification()`
- 백그라운드: `_firebaseMessagingBackgroundHandler` (main.dart)
- 알림 채널: `seeya-notification`

---

## 6. 네이티브 설정

### Android

| 설정 | 위치 |
|------|------|
| applicationId, minSdk, 서명 | `android/app/build.gradle` |
| 권한, 딥링크, Maps API 키, 결제 앱 쿼리 | `AndroidManifest.xml` |
| Naver 로그인 키 | `res/values/strings.xml` |
| Firebase | `google-services.json` |
| Keystore | `android/keystore/` (별도 전달) |

**권한**: INTERNET, FINE/COARSE_LOCATION, READ_MEDIA_IMAGES(33+), READ_MEDIA_VISUAL_USER_SELECTED(34+), READ_EXTERNAL_STORAGE(≤32)

**결제**: AndroidManifest에 한국 결제 앱 패키지 쿼리 등록 (Kakao Pay, Toss, Samsung Pay, ISP 등)

### iOS

| 설정 | 위치 |
|------|------|
| Bundle ID, Team ID | `project.pbxproj` |
| URL Schemes (카카오/구글/네이버/앱) | `Info.plist` |
| 권한 설명 (카메라, 위치, 사진) | `Info.plist` |
| Universal Links | `Runner.entitlements` |
| Maps API 키 초기화 | `AppDelegate.swift` |
| Naver 로그인 키 | `Info.plist` |
| Firebase | `GoogleService-Info.plist` |

**AppDelegate 주의**: URL 핸들링을 직접 분기 처리함 (Kakao/Naver → super, `seeya-app://` → AppLinks). `FlutterDeepLinkingEnabled = false`.

**Background Modes**: fetch, remote-notifications

---

## 7. 외부 서비스 연동

### Firebase (프로젝트 ID: `seeya-bd99d`)

| 서비스 | 용도 | 비고 |
|--------|------|------|
| Messaging | 푸시 알림 | FCM 토큰 로그인 시 서버 전송 |
| Analytics | 이벤트 추적 | debug 모드 비활성화 |
| Crashlytics | 크래시 리포팅 | debug 모드 비활성화 |
| Auth | 전화번호 인증 (SMS) | ReCAPTCHA 사용 |

### 소셜 로그인

| 플랫폼 | 키/설정 위치 |
|--------|-------------|
| Google | `google-services.json` / `GoogleService-Info.plist` |
| Apple | `Runner.entitlements` (Sign In with Apple capability) |
| Kakao | `app_secret.dart` (nativeAppKey), URL Scheme: `kakao{앱키}` |
| Naver | Android: `strings.xml` / iOS: `Info.plist`, URL Scheme: `seeyanaverlogin` |

### API 서버 (DioService)

```
Base URL:    app_secret.dart (프로덕션: https://api-v2.seeya-printer.com)
로컬 개발용:  app_secret.dart 주석 참고 (127.0.0.1:8000 등)
Timeout:     연결/수신/전송 각 15초
기본 헤더:    api-key (app_secret.dart)
인증:        Authorization: Bearer {token}
```

**인터셉터 특이사항**:
- **응답**: ISO 날짜 문자열에 `Z` 접미사 자동 추가 (서버가 UTC 표기 없이 내려줌)
- **401**: 토큰 유효 → 전화번호 인증 필요 / 토큰 무효 → 로그인으로 이동
- **402**: 차단 유저 → `/block`
- **403**: 토큰 만료 → 로그아웃 후 `/login`
- **503**: 서버 점검 → `/server_maintenance`

### Google Maps

- API 키: `app_secret.dart`, Android `AndroidManifest.xml`, iOS `AppDelegate.swift` 각각 설정 필요

---

## 8. 별도 전달 항목

| 항목 | 설명 |
|------|------|
| `android/keystore/` | `seeya_keystore.jks` + `keystore.password` (gitignore 대상, 별도 전달) |
| Google Play Console / App Store Connect | 스토어 배포 권한 (클라이언트 제공) |
| Firebase Console | 푸시, 애널리틱스, 크래시 관리 (클라이언트 제공) |
| Google Cloud Console | Maps API 키 관리 (클라이언트 제공) |
| Kakao / Naver Developers | 소셜 로그인 앱 설정 (클라이언트 제공) |


---
