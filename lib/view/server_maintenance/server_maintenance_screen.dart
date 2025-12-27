import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seeya/core/config/app_colors.dart';
import 'package:seeya/core/config/app_themes.dart';
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
            Text("maintenance.title".tr, style: AppThemes.headline02.copyWith(color: AppColors.blueGrey000),),
            addH(8),
            Text("maintenance.description".tr, style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey000), textAlign: TextAlign.center,),
          ],
        )
      ),
    );
  }

}
