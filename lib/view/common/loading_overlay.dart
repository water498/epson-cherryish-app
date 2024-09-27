import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:seeya/constants/app_themes.dart';

import '../../constants/app_colors.dart';

class LoadingOverlay {

  static OverlayEntry? _overlayEntry;

  static void show(String? msg) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = Get.overlayContext;
      if (context == null) return;

      if (_overlayEntry != null) {
        // 기존 OverlayEntry 제거
        hide();
      }

      _overlayEntry = _createOverlayEntry(msg);
      Overlay.of(context).insert(_overlayEntry!);
    // });
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static OverlayEntry _createOverlayEntry(String? msg) {
    return OverlayEntry(
      builder: (context) => Positioned.fill(
        child: PopScope(
          canPop: false,
          child: Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/image/loading.gif"),
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