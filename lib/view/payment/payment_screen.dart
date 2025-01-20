import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seeya/view/common/common_widget.dart';
import 'package:seeya/view/common/lottie_loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controller/controllers.dart';

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final webViewController = WebViewController()

      ..setUserAgent("seeya_mobile_webview")
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(

          // onNavigationRequest: (NavigationRequest request) async {
          //
          //   //----------------------------------------------------------------------------------------------
          //
          //   if(request.url.contains("seeya-app://pay/print-payment?result=possible&print_queue_id")){
          //     Uri uri = Uri.parse(request.url);
          //     String? printQueueId = uri.queryParameters["print_queue_id"];
          //
          //     if (printQueueId != null) {
          //       Get.back(result: printQueueId);
          //     } else {
          //       Fluttertoast.showToast(msg: "알 수 없는 에러가 발생하였습니다. 다시 시도해주세요.");
          //     }
          //     return NavigationDecision.prevent;
          //   } else if(request.url == "seeya-app://pay/print-payment?result=cancel") {
          //     Get.back();
          //     return NavigationDecision.prevent;
          //   } else if(request.url == "seeya-app://pay/print-payment?result=not_enable") {
          //     Fluttertoast.showToast(msg: "현재 이용할 수 없습니다. 관리자에게 문의해주세요.");
          //     return NavigationDecision.prevent;
          //   } else if(request.url == "seeya-app://pay/print-payment?result=error"){
          //     Fluttertoast.showToast(msg: "알 수 없는 에러가 발생하였습니다. 다시 시도해주세요.");
          //     return NavigationDecision.prevent;
          //   } else {
          //     return NavigationDecision.navigate;
          //   }
          //
          // },

        ),
      )
      ..loadRequest(Uri.parse(controller.webViewUrl));


    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          // handleBackPress(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
            // child: WebViewWidget(controller: webViewController)
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/image/loading02.gif"),
                addH(30),
                Text("결제가 진행중입니다.\n웹에서 결제를 완료해주세요!", textAlign: TextAlign.center,),
              ],
            ),
          ),
        ),
      ),
    );

  }

}
