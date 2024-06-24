import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/view/common/bouncing_button.dart';

import '../../constants/app_router.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/image/login_background.png",fit: BoxFit.cover,),

          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.0, 0.8, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000),Color(0x8A000000),Color(
                      0xBD000000)],
                )
            ),
          ),


          Column(
            children: [

              const SizedBox(height: 50,),

              GestureDetector(
                onTap: () {
                  if(kDebugMode){
                    Get.offAndToNamed(AppRouter.root);
                  }
                },
                child: Image.asset("assets/image/login_logo.png",width: 150,fit: BoxFit.cover,),
              ),

              Expanded(child: Container()),

              
              Row(
                children: [
                  const SizedBox(width: 10,),
                  Expanded(child: Container(color: Colors.white,height: 1,)),
                  const SizedBox(width: 10,),
                  const Text("간편 로그인", style: TextStyle(color: Colors.white, fontSize: 13),),
                  const SizedBox(width: 10,),
                  Expanded(child: Container(color: Colors.white,height: 1,)),
                  const SizedBox(width: 10,),
                ],
              ),

              const SizedBox(height: 10,),
              

              FractionallySizedBox(
                widthFactor: 0.9,
                child: BouncingButton(
                  onTap: () {
                    controller.signInWithGoogle();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 3,bottom: 3, left: 20, right: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset("assets/image/logo_google.png",width: 40,),
                        Expanded(child: Container()),
                        const Text("Continue with Google", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                        Expanded(child: Container()),
                        const Opacity(opacity: 0, child: SizedBox(width: 40,height: 40,),)
                      ],
                    ),
                  ),
                ),
              ),




              if(Platform.isIOS)
              FractionallySizedBox(
                widthFactor: 0.9,
                child: BouncingButton(
                  onTap: () {
                    controller.signInWithApple();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 3,bottom: 3, left: 20, right: 20),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(30))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset("assets/image/logo_apple.png",width: 40,),
                        Expanded(child: Container()),
                        const Text("Continue with Apple",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        Expanded(child: Container()),
                        const Opacity(opacity: 0, child: SizedBox(width: 40,height: 40,),)
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20,),


            ],
          ),
        ],
      ),
    );
  }
}
