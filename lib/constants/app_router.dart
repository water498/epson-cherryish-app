import 'package:get/get.dart';
import 'package:seeya/binding/bindings.dart';

import '../view/screens.dart';

abstract class AppRouter {
  AppRouter._();

  static const String login = '/login';
  static const String root = '/root';
  static const String home = '/home';
  static const String homeDetail = '/home_detail';
  static const String editorLayout = '/editor_layout';
  static const String editorPhoto = '/editor_photo';
  static const String camera = '/camera';
  static const String photo_list = '/photo_list';
  static const String my_page = '/my_page';
  static const String setting = '/setting';
  static const String purchase = '/purchase';


  static final List<GetPage> routes = [
    GetPage(
      name: login,
      page: () => LoginScreen(),
      binding: LoginBinding()
    ),
    GetPage(
      name: root,
      page: () => RootScreen(),
      bindings: [
        HomeBinding(),
        MyPageBinding(),
      ],
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: HomeBinding()
    ),
    GetPage(
        name: homeDetail,
        page: () => HomeDetailScreen(),
        binding: HomeDetailBinding()
    ),
    GetPage(
      name: editorLayout,
      page: () => EditorLayoutScreen(),
      binding: EditorLayoutBinding(),
    ),
    GetPage(
      name: editorPhoto,
      page: () => EditorPhotoScreen(),
    ),
    GetPage(
      name: camera,
      page: () => CameraScreen(),
      binding: CameraBinding(),
    ),
    GetPage(
      name: photo_list,
      page: () => PhotoListScreen(),
    ),
    GetPage(
      name: my_page,
      page: () => MyPageScreen(),
    ),
    GetPage(
      name: setting,
      page: () => SettingScreen(),
    ),
    GetPage(
      name: purchase,
      page: () => PurchaseScreen(),
    ),
  ];


}
