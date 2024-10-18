import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/data/model/models.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_themes.dart';

class HomeDetailDialog extends StatelessWidget {

  final HomeBestFrame selectedItem;

  const HomeDetailDialog({
    required this.selectedItem,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset("assets/image/ic_close.svg", colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),)
              )
          ),
          Expanded(
            child: Center(
              child: CachedNetworkImage(
                imageUrl: Uri.encodeFull("${AppSecret.s3url}${selectedItem.preview_image_filepath}"),
                fit: BoxFit.contain,
                placeholder: (context, url) => Image.asset("assets/image/loading02.gif"),
              ),
            )
          ),

          const SizedBox(height: 13,),

          if(selectedItem.eventId != null)
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(AppRouter.event_detail, arguments: selectedItem.eventId!);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.primary500,
                  border: Border.all(
                      width: 2,
                      color: AppColors.primary400.withOpacity(0.8)
                  )
              ),
              child: Text("이벤트 내용 보러가기", style: AppThemes.headline05.copyWith(color: Colors.white),textAlign: TextAlign.center,),
            ),
          )
        ],
      ),
    );
  }

}
