import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/config/app_colors.dart';
import 'package:seeya/core/config/app_themes.dart';
import 'package:seeya/core/data/enum/social_login_type.dart';
import 'package:seeya/core/services/services.dart';

class SettingSnsIcons extends StatelessWidget {

  const SettingSnsIcons({
    super.key
  });


  @override
  Widget build(BuildContext context) {

    var socialType = UserService.instance.userDetail.value?.socialType;


    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: socialType == SocialLoginType.kakao ? const Color(0xccFFEB00) : AppColors.blueGrey800,
            border: Border.all(
              color: socialType == SocialLoginType.kakao ? const Color(0xffFFEB00) : AppColors.blueGrey600,
              width: 2,
            )
          ),
          child: SvgPicture.asset(
            "assets/image/ic_logo_kakao.svg",
            colorFilter: socialType == SocialLoginType.kakao ? null : const ColorFilter.mode(AppColors.blueGrey600, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 8,),
        Container(
          decoration: BoxDecoration(
              color: socialType == SocialLoginType.naver ? const Color(0xcc04C75B) : AppColors.blueGrey800,
              border: Border.all(
                color: socialType == SocialLoginType.naver ? const Color(0xff04C75B) : AppColors.blueGrey600,
                width: 2,
              )
          ),
          child: SvgPicture.asset(
            "assets/image/ic_logo_naver.svg",
            colorFilter: socialType == SocialLoginType.naver ? null : const ColorFilter.mode(AppColors.blueGrey600, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 8,),
        Container(
          decoration: BoxDecoration(
              color: socialType == SocialLoginType.google ? const Color(0xffffffff) : AppColors.blueGrey800,
              border: Border.all(
                color: socialType == SocialLoginType.google ? AppColors.blueGrey200 : AppColors.blueGrey600,
                width: 2,
              )
          ),
          child: SvgPicture.asset(
            "assets/image/ic_logo_google.svg",
            colorFilter: socialType == SocialLoginType.google ? null : const ColorFilter.mode(AppColors.blueGrey600, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 8,),
        Container(
          decoration: BoxDecoration(
              color: socialType == SocialLoginType.apple ? AppColors.blueGrey100 : AppColors.blueGrey800,
              border: Border.all(
                color: socialType == SocialLoginType.apple ? AppColors.blueGrey000 : AppColors.blueGrey600,
                width: 2,
              )
          ),
          child: SvgPicture.asset(
            "assets/image/ic_logo_apple.svg",
            colorFilter: socialType == SocialLoginType.apple ? null : const ColorFilter.mode(AppColors.blueGrey600, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }

}
