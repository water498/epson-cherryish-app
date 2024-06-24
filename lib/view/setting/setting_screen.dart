import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../controller/controllers.dart';
import '../common/vertical_slider.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("설정"),
      ),
      body: Column(
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

        ],
      ),
    );
  }

}
