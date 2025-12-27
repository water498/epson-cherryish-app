import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:seeya/core/config/app_themes.dart';

import '../../core/config/app_colors.dart';

class LoadingOverlay {

  static OverlayEntry? overlayEntry;

  static void show([String? msg, int? gifType]) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = Get.overlayContext;
      if (context == null) return;

      if (overlayEntry != null) {
        // 기존 OverlayEntry 제거
        hide();
      }

      overlayEntry = _createOverlayEntry(msg, gifType);
      Overlay.of(context).insert(overlayEntry!);
    // });
  }

  static void hide() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  static OverlayEntry _createOverlayEntry(String? msg, int? gifType) {

    String loadingType = "loading03";

    if(gifType == 1){
      loadingType = "loading01";
    } else if (gifType == 2) {
      loadingType = "loading02";
    } else if (gifType == 3) {
      loadingType = "loading03";
    }

    return OverlayEntry(
      builder: (context) => Positioned.fill(
        child: PopScope(
          canPop: false,
          child: Container(
            color: Colors.black54,
            // color: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/image/$loadingType.gif"),
                  // child: Lottie.asset("assets/lottie/loading_cute.json"),
                  Material(
                    type: MaterialType.transparency,
                    child: Text(msg ?? "",style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey800),)
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}