import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeya/controller/controllers.dart';

class CustomSplashScreen extends GetView<CustomSplashController> {
  const CustomSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox.expand(child: Image.asset("assets/image/splash_background.png",fit: BoxFit.cover,)),
        ],
      ),
    );
  }
}
