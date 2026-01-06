import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/view/common/seeya_cached_image.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/config/app_colors.dart';
import '../../core/config/app_secret.dart';
import '../../core/config/app_themes.dart';

class QrShareScreen extends StatelessWidget {

  const QrShareScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(QrShareController());

    final deviceWidth = MediaQuery.of(context).size.width;
    double size = deviceWidth < 600 ? deviceWidth * 0.8 : deviceWidth * 0.5;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SeeyaCachedImage(
                imageUrl : Uri.encodeFull("${AppSecret.s3url}${controller.event.qrImageFilepath}"),
                fit: BoxFit.contain,
                width: size,
                height: size,
              ),
            ),
            GestureDetector(
              onTap: () async {
                // Share.share(controller.event.webLink);
                Share.share("https://www.seeya-printer.com/deeplink/event/${controller.event.id}");
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 24, right: 24, bottom: 20 ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: AppColors.primary500,
                    border: Border.all(
                      width: 2,
                      color: AppColors.primary400.withOpacity(0.8),
                    )
                ),
                child: Text("share.button".tr, style: AppThemes.headline05.copyWith(color: Colors.white),textAlign: TextAlign.center,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
