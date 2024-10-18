import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_themes.dart';
import 'package:seeya/view/common/common_widget.dart';

class ServerMaintenanceScreen extends StatelessWidget {
  const ServerMaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/image/ic_warning_red.svg"),
            addH(20),
            Text("서비스 점검중입니다.", style: AppThemes.headline02.copyWith(color: AppColors.blueGrey000),),
            addH(8),
            Text("안전한 서비스 제공을 위해\n현재 서비스를 점검하고 있습니다.", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey000), textAlign: TextAlign.center,),
          ],
        )
      ),
    );
  }

}
