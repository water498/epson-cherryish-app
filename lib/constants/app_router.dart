import 'package:get/get.dart';
import 'package:seeya/binding/bindings.dart';
import 'package:seeya/view/test/test_screen.dart';

import '../view/screens.dart';

abstract class AppRouter {
  AppRouter._();

  static const String root = '/root';
  static const String home = '/home';
  static const String login = '/login';
  static const String camera = '/camera';
  static const String purchase = '/purchase';
  static const String image_list_viewer = '/image_list_viewer';
  static const String search = '/search';
  static const String qr_scan = '/qr_scan';
  static const String event_detail = '/event_detail';
  static const String decorate_frame = '/decorate_frame';
  static const String seeya_guide = '/seeya_guide';
  static const String print_history= '/print_history';
  static const String qna = '/qna';
  static const String custom_splash = '/custom_splash';
  static const String enter_user_info = '/enter_user_info';
  static const String sign_up_finish = '/sign_up_finish';
  static const String report = '/report';
  static const String error_report = '/error_report';
  static const String inquiry_detail = '/inquiry_detail';
  static const String phone_verification = '/phone_verification';
  static const String image_crop = '/image_crop';
  static const String setting = '/setting';
  static const String withdrawal = '/withdrawal';


  static const String test = '/test';


  static final List<GetPage> routes = [
    GetPage(
      name: root,
      page: () => RootScreen(),
      transition: Transition.noTransition,
      binding: RootBinding(),
      bindings: [
        HomeBinding(),
        MapTabBinding(),
        MyPageBinding(),
      ],
    ),
    GetPage(
        name: home,
        page: () => HomeScreen(),
        binding: HomeBinding()
    ),
    GetPage(
      name: login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: camera,
      page: () => CameraScreen(),
      binding: CameraBinding(),
    ),
    GetPage(
      name: purchase,
      page: () => PurchaseScreen(),
      binding: PurchaseBinding(),
    ),
    GetPage(
      name: image_list_viewer,
      page: () => ImageListViewerScreen(),
      binding: ImageListViewerBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: search,
      page: () => SearchScreen(),
      transition: Transition.noTransition
    ),
    GetPage(
      name: qr_scan,
      page: () => QrScanScreen(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 200)
    ),
    GetPage(
      name: event_detail,
      page: () => EventDetailScreen(),
    ),
    GetPage(
      name: decorate_frame,
      page: () => DecorateFrameScreen(),
      transition: Transition.noTransition,
      popGesture: false // 뒤로가기 제어
    ),
    GetPage(
      name: seeya_guide,
      page: () => SeeyaGuideScreen(),
    ),
    GetPage(
      name: print_history,
      page: () => PrintHistoryScreen(),
    ),
    GetPage(
      name: qna,
      page: () => QnaScreen(),
    ),
    GetPage(
      name: custom_splash,
      page: () => CustomSplashScreen(),
      binding: CustomSplashBinding(),
    ),
    GetPage(
      name: enter_user_info,
      page: () => EnterUserInfoScreen(),
    ),
    GetPage(
      name: sign_up_finish,
      page: () => SignUpFinishScreen(),
    ),
    GetPage(
      name: report,
      page: () => ReportScreen(),
    ),
    GetPage(
      name: error_report,
      page: () => ErrorReportScreen(),
    ),
    GetPage(
      name: inquiry_detail,
      page: () => InquiryDetailScreen(),
    ),
    GetPage(
      name: phone_verification,
      page: () => PhoneVerificationScreen(),
      binding: PhoneVerificationBinding(),
    ),
    GetPage(
      name: image_crop,
      page: () => ImageCropScreen(),
    ),
    GetPage(
      name: setting,
      page: () => SettingScreen(),
    ),
    GetPage(
      name: withdrawal,
      page: () => WithdrawalScreen(),
    ),





    GetPage(
      name: test,
      page: () => TestScreen(),
    ),
  ];


}
