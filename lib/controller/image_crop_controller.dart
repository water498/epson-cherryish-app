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
import 'package:seeya/core/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';
import 'package:image/image.dart' as img;
import 'package:seeya/core/config/seeya_frame_configs.dart';

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

      // Capture the boundary as image
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Decode the captured image
      final capturedImage = img.decodeImage(pngBytes);
      if (capturedImage == null) {
        throw Exception("Failed to decode captured image");
      }

      // Resize to exact filter dimensions (786x1064) - same as camera
      final resizedImage = img.copyResize(
        capturedImage,
        width: SeeyaFrameConfigs.filterWidth.toInt(),  // 786
        height: SeeyaFrameConfigs.filterHeight.toInt(), // 1064
        interpolation: img.Interpolation.linear,
      );

      // Encode back to PNG
      final finalBytes = Uint8List.fromList(img.encodePng(resizedImage));

      await _saveImage(finalBytes, "${const Uuid().v4()}.png");
    } catch(e){
      Logger().e("Error capturing image: $e");
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