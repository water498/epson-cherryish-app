import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeya/controller/controllers.dart';

import '../../../constants/app_secret.dart';

class ImageListViewerScreen extends GetView<ImageListViewerController> {
  const ImageListViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Obx(() {
          return Text("${controller.currentIndex.value + 1}/${controller.photoLayouts.length}", style: const TextStyle(color: Colors.black),);
        },),
      ),
      body: Obx(() {

        return Center(
          child: FractionallySizedBox(
            heightFactor: 0.8,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.photoLayouts.length,
              controller: controller.pageController,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CachedNetworkImage(
                    imageUrl: Uri.encodeFull("${AppSecret.s3url}${controller.photoLayouts[index].thumbnail_image_filepath}"),
                    fit: BoxFit.contain
                  ),
                );
              },
            ),
          ),
        );

      },),
    );
  }

}
