import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/view/common/bouncing_button.dart';
import 'package:seeya/view/common/login_component.dart';

import '../../constants/app_router.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset("assets/image/ic_close.svg"),
          ),
          const SizedBox(width: 8,),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoginComponent(
            onLoginSuccess: () {
              Get.back(result: "success");
            },
          ),
        ],
      ),
    );
  }

}
