import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/utils/file_utils.dart';
import 'package:seeya/view/common/lottie_loading.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_secret.dart';

class PurchaseScreen extends GetView<PurchaseController> {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [




                Container(
                  color: const Color(0xfff5f5f5),
                  child: SafeArea(
                    top: true,
                    bottom: false,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: FractionallySizedBox(
                        heightFactor: 0.8,
                        widthFactor: 0.8,
                        child: Stack(
                          children: [
                            Center(
                              child: CachedNetworkImage(
                                imageUrl: Uri.encodeFull("${AppSecret.s3url}${controller.photoProduct!.merged_thumbnail_image_filepath}"),
                                fit: BoxFit.contain,
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),








                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [


                      const SizedBox(height: 20,),
                      Text("${controller.photoProduct?.title ?? ""}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

                      const SizedBox(height: 50,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("매수", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),


                          Obx(() {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    if(controller.copiesCount.value >1){
                                      controller.copiesCount.value -=1;
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("-",style: TextStyle(fontSize: 30, color: controller.copiesCount.value == 1 ? AppColors.grey100 : Colors.black),),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                SizedBox(
                                    width: 30,
                                    child: Align(alignment: Alignment.center,
                                        child: Text("${controller.copiesCount.value}",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),))
                                ),
                                const SizedBox(width: 10,),
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    if(controller.copiesCount.value <5){
                                      controller.copiesCount.value +=1;
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("+",style: TextStyle(fontSize: 30, color: controller.copiesCount.value == 5 ? AppColors.grey100 : Colors.black),),
                                  ),
                                )
                              ],
                            );
                          },),
                        ],
                      ),

                      const SizedBox(height: 20,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("가격", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Expanded(child: const SizedBox()),
                          Text("0원", style: TextStyle(color: AppColors.main700, fontSize: 30,fontWeight: FontWeight.bold),),
                          const SizedBox(width: 5,),
                          Text("0원", style: TextStyle(color: AppColors.grey200, fontSize: 25,decoration: TextDecoration.lineThrough,decorationColor: AppColors.grey200),),
                        ],
                      ),


                      // const SizedBox(height: 20,),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     const Text("상태", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      //     const Expanded(child: SizedBox()),
                      //     Text("${controller.photoProduct?.status}", style: TextStyle(color: Colors.black, fontSize: 30,fontWeight: FontWeight.bold),),
                      //   ],
                      // ),




                      const SizedBox(height: 300,)
                    ],
                  ),
                ),

              ],
            ),
          ),


          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Text("",style: TextStyle(fontSize: 12),),
                Container(
                  width: double.infinity,
                  color: AppColors.grey500,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextButton(onPressed: () {
                    PrinterRequestModel request = PrinterRequestModel(
                      photo_product_uid: controller.photoProduct!.uid,
                      copies: controller.copiesCount.value,
                    );
                    controller.requestPint(request);
                  }, child: const SafeArea(
                      top: false,
                      bottom: true,
                      child: Text("구매하기", style: TextStyle(color: AppColors.main700),))
                  ),
                ),
              ],
            ),
          ),



          Obx(() {
            if(controller.isLoading.value){
              return const LottieLoading(text: "인쇄 중입니다.",);
            }else {
              return const SizedBox();
            }
          },)


        ],
      ),
    );
  }

}
