import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seeya/core/config/app_themes.dart';

import '../../core/config/app_colors.dart';

class CommonDialog extends StatelessWidget {

  final bool showLine;
  final bool needWarning;
  final bool needAppBar;
  final String? appBarText;
  final bool showAppbarClose;
  final String? title;
  final String? description;
  final String? button01text;
  final String? button02text;
  final VoidCallback? onButton01Click;
  final VoidCallback? onButton02Click;

  const CommonDialog({
    this.showLine = false,
    this.needWarning = false,
    this.needAppBar = false,
    this.showAppbarClose = true,
    this.appBarText = "",
    this.title = "",
    this.description = "",
    this.button01text,
    this.button02text,
    this.onButton01Click,
    this.onButton02Click,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(


      shape: const LinearBorder(),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      iconPadding: EdgeInsets.zero,


      actions: [

        Container(
          decoration: showLine ? BoxDecoration(
            border: Border.all(
              color: AppColors.blueGrey600,
              width: 2
            )
          ) : null,
          child: Column(
            children: [
              if(needAppBar)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.blueGrey500,
                        width: 2
                      )
                    ),
                    color: AppColors.blueGrey700
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Padding(
                        padding: const EdgeInsets.only(left: 24, top: 10, bottom: 10, right: 24),
                        child: Text("$appBarText", style: AppThemes.headline05.copyWith(color: AppColors.blueGrey100),),
                      )),
                      if(showAppbarClose)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SvgPicture.asset("assets/image/ic_close_with_box.svg")
                      ),
                    ],
                  ),
                ),
              if(needWarning)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffFF7E7E),
                    border: Border.all(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SvgPicture.asset("assets/image/ic_warning.svg"),
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 34,),
                    if(needWarning) Text("decorate_frame_confirm_dialog.warning".tr, style: AppThemes.headline04.copyWith(color: AppColors.error),),
                    Text(title ?? "", style: AppThemes.headline04.copyWith(color: AppColors.blueGrey000),textAlign: TextAlign.center,),
                    if(description != null && description!.isNotEmpty) const SizedBox(height: 4,),
                    if(description != null && description!.isNotEmpty)
                    Text(description!,style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),textAlign: TextAlign.center,),
                    const SizedBox(height: 48,),
                    if(button01text != null && onButton01Click != null)
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.of(context).pop();
                          onButton01Click!();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 2,
                                  color: AppColors.primary400
                              )
                          ),
                          child: Text(button01text!, style: AppThemes.headline05.copyWith(color: AppColors.primary400),textAlign: TextAlign.center,),
                        ),
                      ),
                    if(button02text != null && onButton02Click != null)
                      const SizedBox(height: 8,),
                    if(button02text != null && onButton02Click != null)
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.of(context).pop();
                          onButton02Click!();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: AppColors.primary400.withOpacity(0.8),
                              border: Border.all(
                                  width: 2,
                                  color: AppColors.primary400
                              )
                          ),
                          child: Text(button02text!, style: AppThemes.headline05.copyWith(color: Colors.white),textAlign: TextAlign.center,),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],

    );
  }

}
