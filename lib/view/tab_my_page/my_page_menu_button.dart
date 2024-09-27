import 'package:flutter/material.dart';
import 'package:seeya/constants/app_themes.dart';

import '../../constants/app_colors.dart';

class MyPageMenuButton extends StatelessWidget {

  final VoidCallback onTap;
  final String title;
  final Widget? trailing;
  final Color? textColor;
  final bool? showDivider;

  const MyPageMenuButton({
    required this.title,
    this.trailing,
    required this.onTap,
    this.textColor = AppColors.blueGrey100,
    this.showDivider = true,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 24, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppThemes.headline05.copyWith(color: textColor),),
                if(trailing != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: trailing!,
                  ),
              ],
            ),
          ),
          if(showDivider == true)
          const Divider(height: 1,thickness: 1, color: AppColors.blueGrey800,)
        ],
      ),
    );
  }


}