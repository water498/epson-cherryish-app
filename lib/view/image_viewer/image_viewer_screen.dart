import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/config/app_colors.dart';
import 'package:seeya/view/common/seeya_cached_image.dart';

class ImageViewerScreen extends GetView<ImageViewerController> {

  const ImageViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(ImageViewerController());

    Logger().d("${controller.heroTag}");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.blueGrey100,
        actions: [
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset("assets/image/ic_close.svg", colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),)
          ),
          const SizedBox(width: 8,),
        ],
      ),
      backgroundColor: AppColors.blueGrey100,
      body: Center(
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          constrained: true,
          child: Hero(
            tag: controller.heroTag,
            child: SeeyaCachedImage(
              imageUrl: Uri.encodeFull(controller.imagePath),
            ),
          ),
        ),
      ),
    );
  }
}


class ImageViewerController extends GetxController{

  late String imagePath;
  late String heroTag;

  @override
  void onInit() {
    imagePath = Get.arguments["image_path"];
    heroTag = Get.arguments["hero_tag"];
    super.onInit();
  }

}
