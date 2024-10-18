import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_themes.dart';
import 'package:seeya/data/enum/enums.dart';
import 'package:seeya/service/services.dart';

class SettingSnsIcons extends StatelessWidget {

  const SettingSnsIcons({
    super.key
  });


  @override
  Widget build(BuildContext context) {

    var socialTypeString = UserService.instance.userPublicInfo.value?.social_type;
    var socialType = LoginPlatformUtils.stringToEnum(socialTypeString);


    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: socialType == LoginPlatform.kakao ? const Color(0xccFFEB00) : AppColors.blueGrey800,
            border: Border.all(
              color: socialType == LoginPlatform.kakao ? const Color(0xffFFEB00) : AppColors.blueGrey600,
              width: 2,
            )
          ),
          child: SvgPicture.asset(
            "assets/image/ic_logo_kakao.svg",
            colorFilter: socialType == LoginPlatform.kakao ? null : const ColorFilter.mode(AppColors.blueGrey600, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 8,),
        Container(
          decoration: BoxDecoration(
              color: socialType == LoginPlatform.naver ? const Color(0xcc04C75B) : AppColors.blueGrey800,
              border: Border.all(
                color: socialType == LoginPlatform.naver ? const Color(0xff04C75B) : AppColors.blueGrey600,
                width: 2,
              )
          ),
          child: SvgPicture.asset(
            "assets/image/ic_logo_naver.svg",
            colorFilter: socialType == LoginPlatform.naver ? null : const ColorFilter.mode(AppColors.blueGrey600, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 8,),
        Container(
          decoration: BoxDecoration(
              color: socialType == LoginPlatform.google ? const Color(0xffffffff) : AppColors.blueGrey800,
              border: Border.all(
                color: socialType == LoginPlatform.google ? AppColors.blueGrey200 : AppColors.blueGrey600,
                width: 2,
              )
          ),
          child: SvgPicture.asset(
            "assets/image/ic_logo_google.svg",
            colorFilter: socialType == LoginPlatform.google ? null : const ColorFilter.mode(AppColors.blueGrey600, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 8,),
        Container(
          decoration: BoxDecoration(
              color: socialType == LoginPlatform.apple ? AppColors.blueGrey100 : AppColors.blueGrey800,
              border: Border.all(
                color: socialType == LoginPlatform.apple ? AppColors.blueGrey000 : AppColors.blueGrey600,
                width: 2,
              )
          ),
          child: SvgPicture.asset(
            "assets/image/ic_logo_apple.svg",
            colorFilter: socialType == LoginPlatform.apple ? null : const ColorFilter.mode(AppColors.blueGrey600, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }

}
