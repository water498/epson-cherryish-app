import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_router.dart';

import '../constants/app_prefs_keys.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';
import '../service/services.dart';
import '../view/screens.dart';
import 'controllers.dart';

class RootController extends GetxController{

  var currentIndex = 0.obs;
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  final Map<int, Widget> tabPages = {
    0: const HomeScreen(),
  };




  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initDeepLink();
    });

  }



  @override
  void onClose() {
    _linkSubscription = null;
    super.onClose();
  }





  void initDeepLink(){
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      openAppLink(uri);
    });
  }



  void openAppLink(Uri uri){
    Logger().d("uri fragment : ${uri.pathSegments}");
    Logger().d("uri param : ${uri.queryParameters}");
    Logger().d("uri data : ${uri.data}");

    var pathSegments = uri.pathSegments;
    var joinedPath = '/${pathSegments.join('/')}';

    if (pathSegments.contains("event") && pathSegments.length >= 2) {

      try{
        var eventId = int.parse(pathSegments.last);
        Get.toNamed(AppRouter.event_detail, arguments: eventId);
      }catch (e){
        Logger().e("deeplink event id parsing error");
      }

    }

  }



  void onTabTapped(int index) {

    if (!tabPages.containsKey(index)) {
      switch (index) {
        case 1:
          tabPages[index] = const MapTabScreen();
          break;
        case 2:
          tabPages[index] = const MyPageScreen();
          break;
      }
    }

    if(index == 2){
      onMyPageClick();
    }

    currentIndex.value = index;
  }
  
  
  void onSearchClick(){
    onTabTapped(1);
    var eventApi = Get.put(EventApi());
    var mapTabRepository = Get.put(MapTabRepository(eventApi: eventApi));
    var mapTabController = Get.put(MapTabController(mapTabRepository: mapTabRepository));
    mapTabController.openSearch();
  }

  void onMyPageClick(){
    var authApi = Get.put(AuthApi());
    var myPageRepository = Get.put(MyPageRepository(authApi: authApi));
    var myPageController = Get.put(MyPageController(myPageRepository: myPageRepository));
    myPageController.validateToken();
  }

}