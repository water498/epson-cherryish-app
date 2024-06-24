import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_router.dart';
import '../../controller/controllers.dart';

class MyPageScreen extends GetView<MyPageController> {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            Get.toNamed(AppRouter.setting);
          }, icon: Icon(Icons.settings)),
        ],
      ),
      body: Column(
        children: [
          Container(height: 100,width: 100,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.grey),),
          ElevatedButton(onPressed: () {

          }, child: Text("개인정보")),
          ElevatedButton(onPressed: () {
            controller.signOut();
          }, child: Text("로그아웃")),
          ElevatedButton(onPressed: () {
            controller.signOut();
          }, child: Text("탈퇴하기")),
        ],
      ),
    );
  }

}


