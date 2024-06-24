import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gal/gal.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/data/model/models.dart';

import '../utils/file_utils.dart';
import '../utils/image_utils.dart';

class CameraScreenController extends GetxController{


  // camera
  CameraController? cameraController;
  late List<CameraDescription> descriptions;

  var isInitialized = false.obs;
  var showFlashAnim = false.obs;
  var showImage = false.obs;
  var isImgProcessing = false.obs;

  // image files
  File? currentMergedImageFile;

  // filter
  late PhotoFilter photoFilter;



  @override
  void onInit() {

    photoFilter = Get.arguments;

    initCameraController();
    super.onInit();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    cameraController = null;
    super.onClose();
  }

  void startFlashAnim() {
    showFlashAnim.value = true;
    Future.delayed(Duration(seconds: 1), () {
      showFlashAnim.value = false;
    });
  }

  Future<void> initCamera() async {

    PermissionStatus cameraPermissionStatus = await Permission.camera.request();
    if(cameraPermissionStatus.isDenied){
      Get.snackbar("⚠️", "권한을 허용해 주세요.",colorText: Colors.white);
      Get.back();
      return;
    }

    if (!(await Gal.hasAccess())) {
      await Gal.requestAccess();
    }

    descriptions = await availableCameras();
    cameraController = CameraController(descriptions[1], ResolutionPreset.ultraHigh);

    cameraController?.initialize().then((_) {
      cameraController?.setFlashMode(FlashMode.off);
      isInitialized(true);
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("CameraController Error : CameraAccessDenied");
            // Handle access errors here.
            break;
          default:
            print("CameraController Error");
            // Handle other errors here.
            break;
        }
      }
    });
  }

  Future<void> initCameraController() async {
    await initCamera();
  }


  Future<File?> takePicture() async {
    if(cameraController == null){
      return null;
    }
    if (!cameraController!.value.isInitialized) {
      return null;
    }


    try {
      startFlashAnim();
      final XFile tempFile = await cameraController!.takePicture();


      await Future.delayed(const Duration(milliseconds: 200));
      isImgProcessing(true);


      var ratio = photoFilter.height/photoFilter.width;

      // fit & rotate
      await ImageUtils().fixRotateAndFlipImage(tempFile.path);

      // picture image properties
      ImageProperties properties = await FlutterNativeImage.getImageProperties(tempFile.path);
      var width = properties.width!;
      var height = properties.height!;
      Logger().d("temp file 즉 원본이미지 - orientation ::: ${properties.orientation} width ::: ${width} height :::: ${height}");

      double targetHeight = width * (ratio);
      int offsetX = 0;
      int offsetY = (height - targetHeight) ~/ 2;

      final croppedUserImageFile = await FlutterNativeImage.cropImage(tempFile.path, offsetX, offsetY, width, (width*(ratio)).toInt());
      final overlayImage = await FileUtils.findFileFromUrl("${AppSecret.s3url}${photoFilter.thumbnail_image_filepath}");

      final finalImage = await ImageUtils().overlayImages(width, (width*(ratio)).toInt(), croppedUserImageFile, overlayImage);
      Logger().d("finalImage path ::: ${finalImage.path}");

      Gal.putImage(finalImage.path);

      isImgProcessing(false);

      return File(finalImage.path);
    } catch (e) {
      isImgProcessing(false);
      Logger().e('Error taking picture: $e');
      return null;
    }
  }


}