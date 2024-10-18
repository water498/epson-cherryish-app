import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_secret.dart';
import '../../constants/app_themes.dart';

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
              child: CachedNetworkImage(
                imageUrl : Uri.encodeFull("${AppSecret.s3url}${controller.eventModel.qr_image_filepath}"),
                fit: BoxFit.contain,
                width: size,
                height: size,
                placeholder: (context, url) => Image.asset("assets/image/loading02.gif"),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Share.share(controller.eventModel.web_link);
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
                child: Text("링크 공유하기", style: AppThemes.headline05.copyWith(color: Colors.white),textAlign: TextAlign.center,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
