import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_router.dart';

import '../common/loading_overlay.dart';
import '../common/vertical_slider.dart';


class TestController extends GetxController{

  

}
















class TestScreen extends GetView<TestController> {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(TestController());
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("테스트", style: TextStyle(color: Colors.blue),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VerticalSlider(
              min: 0,
              max: 100,
              speedFactor: 0.3,
              thumbColor: Colors.white,
              sliderColor: Colors.grey,
              sliderShape: SliderShape.downwardTriangle,
              width: 30,
              height: 300,
              onChanged: (value) {
                Logger().d("value ::: ${value}");
              },
              onMinReached: () {
                Logger().d("min reached !!!!");
              },
              onMaxReached: () {
                Logger().d("max reached !!!!");
              },
            ),
        
            ElevatedButton(onPressed: () async {
              LoadingOverlay.show(null);
              await Future.delayed(const Duration(milliseconds: 500));
              LoadingOverlay.hide();
            }, child: Text("loading show")),
        
        
        
        
        
        
            ElevatedButton(onPressed: () async {
              Get.toNamed(AppRouter.enter_user_info);
            }, child: Text("enter user info")),
        
        
            ElevatedButton(onPressed: () async {
              Get.toNamed(AppRouter.phone_verification);
            }, child: Text("nice 인증")),
        
        
        
        
        
        
        
        
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: deviceWidth / 2 - 35),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index % 2 == 0 ? Colors.blue : Colors.red
                    ),
                    width: 50,
                    height: 50,
                  );
                },
              ),
            ),
        
        
        
        
            ElevatedButton(onPressed: () {
        
            }, child: Text("in app purchase"))
        
        
        
        
          ],
        ),
      ),
    );
  }

}
