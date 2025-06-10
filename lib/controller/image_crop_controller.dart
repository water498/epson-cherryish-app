import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

class ImageCropController extends GetxController{

  final GlobalKey boundaryKey = GlobalKey();
  late File selectedImage;
  late EventFilterModel filter;

  late double imageWidth;
  late double imageHeight;
  var initialScale = 0.0;
  var cropRectWidth = 0.0;
  var cropRectHeight = 0.0;
  var x = 0.0.obs;
  var y = 0.0.obs;
  var scale = 0.0.obs;
  double previousScale = 1.0;

  var isCapturing = false.obs;
  var isInitialized = false.obs;
  var isGesturing = false.obs;


  @override
  void onInit() {
    selectedImage = File((Get.arguments["selected_image"] as XFile).path);
    filter = Get.arguments["filter"] as EventFilterModel;
    init(selectedImage);
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }



  Future<void> init(File image) async {
    Map<String, int> dimensions = await ImageUtils.getImageDimensions(image);
    imageWidth = dimensions['width']?.toDouble() ?? 0.0;
    imageHeight = dimensions['height']?.toDouble() ?? 0.0;

    if(imageWidth == 0.0 || imageHeight == 0.0){
      Get.back();
      Fluttertoast.showToast(msg: "image_crop.toast.size_error".tr);
      return;
    }
    isInitialized(true);
  }

  Future<void> captureImage() async {
    try{
      isCapturing(true);
      await Future.delayed(const Duration(milliseconds: 200));

      RenderRepaintBoundary boundary = boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // final originalRatio = imageHeight / boundary.size.height;
      final originalRatio = 786 / boundary.size.width;
      Logger().d("originalRatio ::: ${originalRatio}");
      final image = await boundary.toImage(pixelRatio: originalRatio);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      await _saveImage(pngBytes, "${const Uuid().v4()}.png");
    } catch(e){
      isCapturing(false);
    } finally {

    }
  }

  Future<void> _saveImage(Uint8List pngBytes, String fileName) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    String filePath = '$directory/$fileName';
    File imgFile = File(filePath);
    await imgFile.writeAsBytes(pngBytes);
    print('Image saved at $filePath');

    // TODO 에러처리
    // TODO 캐시 처리
    Get.back(result: imgFile);
  }



}