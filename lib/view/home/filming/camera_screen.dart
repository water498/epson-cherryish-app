import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/view/common/bouncing_button.dart';
import 'package:seeya/view/common/lottie_loading.dart';

import '../../../constants/app_router.dart';

class CameraScreen extends GetView<CameraScreenController> {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [


                      Obx(() {

                        if(controller.isInitialized.value){
                          return AspectRatio(
                              aspectRatio: controller.photoFilter.width/controller.photoFilter.height,
                              child: ClipRect(
                                child: Transform.scale(
                                  scale: controller.photoFilter.height/controller.photoFilter.width,
                                  child: Center(
                                      child: CameraPreview(controller.cameraController!)
                                  ),
                                ),
                              )
                          );
                        }else {
                          return Container(color: Colors.black);
                        }
                      }),



                      AspectRatio(
                        aspectRatio: controller.photoFilter.width/controller.photoFilter.height,
                        child: CachedNetworkImage(imageUrl: Uri.encodeFull("${AppSecret.s3url}${controller.photoFilter.original_image_filepath}"),fit: BoxFit.fill),
                      ),




                    ],
                  ),
                )
              ),

              Obx(() {
                if(controller.isInitialized.value){
                  return SafeArea(
                    top: false,
                    bottom: true,
                    child: BouncingButton(
                        onTap: () async {
                          final File? file = await controller.takePicture();
                          Get.back(result: file);
                        },
                        child: Container(
                          width: 60,height: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              )
                          ),
                          child: Container(
                            width: 60,height: 60,
                            margin: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                            ),
                          ),
                        )
                    ),
                  );
                }else {
                  return const SizedBox();
                }
              },),

            ],
          ),


          Obx(() {
            if(controller.isImgProcessing.value){
              return const LottieLoading();
            }else {
              return const SizedBox();
            }
          },)

        ],
      ),
    );
  }

}


