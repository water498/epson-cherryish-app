import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/data/model/models.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_router.dart';

class PaymentController extends GetxController{

  String webViewUrl = "";
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void onInit() {
    var eventId = Get.arguments["event_id"] as int;
    var userId = Get.arguments["user_id"] as int;
    var s3Filepath = Get.arguments["s3_filepath"] as String?;

    webViewUrl = "${AppSecret.clientDomain}/mobile-payment?event_id=$eventId&mobile_user_id=$userId";
    if (s3Filepath != null) {
      webViewUrl += "&s3_filepath=$s3Filepath";
    }

    Logger().d("url ::: $webViewUrl");
    super.onInit();
  }

  @override
  void onReady() {
    initDeepLink();
    super.onReady();
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
    super.onClose();
  }

  void initDeepLink() async {
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      openAppLink(uri);
    });

    final url = Uri.parse(webViewUrl);
    if(await canLaunchUrl(url)){
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void openAppLink(Uri uri){
    Logger().d("uri : $uri"); // seeya-app://pay/print-payment?result=possible&print_queue_id=12


    if(uri.toString().contains("seeya-app://pay/print-payment?result=possible&print_queue_id")){
      String? printQueueId = uri.queryParameters["print_queue_id"];

      if (printQueueId != null) {
        Get.back(result: int.tryParse(printQueueId) ?? -1);
      } else {
        Fluttertoast.showToast(msg: "알 수 없는 에러가 발생하였습니다. 다시 시도해주세요.");
      }
    } else if(uri.toString() == "seeya-app://pay/print-payment?result=cancel") {
      Get.back();
    } else if(uri.toString() == "seeya-app://pay/print-payment?result=not_enable") {
      Fluttertoast.showToast(msg: "현재 이용할 수 없습니다. 관리자에게 문의해주세요.");
      Get.back();
    } else if(uri.toString() == "seeya-app://pay/print-payment?result=error"){
      Fluttertoast.showToast(msg: "알 수 없는 에러가 발생하였습니다. 다시 시도해주세요.");
      Get.back();
    }

  }



}