import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_themes.dart';
import 'package:seeya/data/enum/enums.dart';

import 'bouncing_button.dart';

class SnsLoginButton extends StatelessWidget {

  final VoidCallback onTap;
  final LoginPlatform socialType;

  const SnsLoginButton({
    required this.onTap,
    required this.socialType,
    super.key
  });


  @override
  Widget build(BuildContext context) {

    var buttonColor = Colors.white;
    var strokeColor = Colors.white;
    var textColor = AppColors.blueGrey000;
    var iconPath = "";
    var platformText = "";

    switch (socialType){
      case LoginPlatform.kakao : {
        buttonColor = const Color(0xccFFEB00);
        strokeColor = const Color(0xffFFEB00);
        iconPath = "assets/image/ic_logo_kakao.svg";
        platformText = "카카오";
        break;
      }
      case LoginPlatform.naver : {
        buttonColor = const Color(0xcc04C75B);
        strokeColor = const Color(0xff04C75B);
        iconPath = "assets/image/ic_logo_naver.svg";
        platformText = "네이버";
        break;
      }
      case LoginPlatform.google : {
        buttonColor = const Color(0xffffffff);
        strokeColor = AppColors.blueGrey200;
        iconPath = "assets/image/ic_logo_google.svg";
        platformText = "Google";
        break;
      }
      case LoginPlatform.apple : {
        buttonColor = AppColors.blueGrey100;
        strokeColor = AppColors.blueGrey000;
        iconPath = "assets/image/ic_logo_apple.svg";
        platformText = "Apple";
        textColor = Colors.white;
        break;
      }
      default : {

      }
    }

    return BouncingButton(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          border: Border.all(
            color: strokeColor,
            width: 2,
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(iconPath),
            Text("$platformText로 시작하기", style: AppThemes.bodyMedium.copyWith(color: textColor),),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: false,
              child: SvgPicture.asset(iconPath)
            ),
          ],
        ),
      ),
    );
  }

}
