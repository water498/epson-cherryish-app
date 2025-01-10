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
  static const String qr_share = '/qr_share';
  static const String server_maintenance = '/server_maintenance';
  static const String block = '/block';
  static const String image_viewer = '/image_viewer';
  static const String payment = '/payment';


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
      fullscreenDialog: true,
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 250)
    ),
    GetPage(
      name: camera,
      page: () => CameraScreen(),
      binding: CameraBinding(),
    ),
    GetPage(
      name: search,
      page: () => SearchScreen(),
      binding: SearchScreenBinding(),
      transition: Transition.noTransition,

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
      binding: EventDetailBinding(),
    ),
    GetPage(
      name: decorate_frame,
      page: () => DecorateFrameScreen(),
      binding: DecorateFrameBinding(),
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
      binding: PrintHistoryBinding(),
    ),
    GetPage(
      name: qna,
      page: () => QnaScreen(),
      binding: QnaBinding()
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
      binding: ReportBinding(),
    ),
    GetPage(
      name: error_report,
      page: () => ErrorReportScreen(),
      binding: ErrorReportBinding(),
    ),
    GetPage(
      name: inquiry_detail,
      page: () => InquiryDetailScreen(),
      binding: InquiryDetailBinding(),
    ),
    GetPage(
      name: phone_verification,
      page: () => PhoneVerificationScreen(),
      binding: PhoneVerificationBinding(),
      fullscreenDialog: true, // for hide ios black background
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 250)
    ),
    GetPage(
      name: image_crop,
      page: () => ImageCropScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: setting,
      page: () => SettingScreen(),
      binding: SettingBinding()
    ),
    GetPage(
      name: withdrawal,
      page: () => WithdrawalScreen(),
      binding: WithdrawalBinding(),
    ),
    GetPage(
      name: qr_share,
      page: () => QrShareScreen(),
      fullscreenDialog: true,
      opaque: false, // 불투면한 ? => 투명 scaffold
      popGesture: false, // 뒤로가기 제어
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: server_maintenance,
      page: () => ServerMaintenanceScreen(),
      fullscreenDialog: true,
    ),
    GetPage(
      name: block,
      page: () => BlockScreen(),
      fullscreenDialog: true,
    ),
    GetPage(
      name: image_viewer,
      page: () => ImageViewerScreen(),
      fullscreenDialog: true,
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300)
    ),
    GetPage(
      name: payment,
      page: () => PaymentScreen(),
      binding: PaymentBinding(),
      fullscreenDialog: true,
      opaque: false, // 불투면한 ? => 투명 scaffold
      popGesture: false, // 뒤로가기 제어
    ),




    GetPage(
      name: test,
      page: () => TestScreen(),
    ),
  ];


}
