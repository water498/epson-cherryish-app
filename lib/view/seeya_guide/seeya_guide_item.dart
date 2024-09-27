import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_themes.dart';

class SeeyaGuideItem extends StatelessWidget {

  final String imgUrl;
  final String step;
  final String title;
  final String description;

  const SeeyaGuideItem({
    required this.imgUrl,
    required this.step,
    required this.title,
    required this.description,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40,),
        Image.asset(
          imgUrl,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: 12,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Text(title,style: AppThemes.headline03.copyWith(color: AppColors.blueGrey100), textAlign: TextAlign.center,),),
          ],
        ),
        const SizedBox(height: 4,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(description, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300), textAlign: TextAlign.center,),
        ),
        const SizedBox(height: 40,),
      ],
    );
  }

}
