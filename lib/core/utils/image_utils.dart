import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:fc_native_image_resize/fc_native_image_resize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

import 'package:image_editor/image_editor.dart';
import 'package:logger/logger.dart';
import 'package:native_exif/native_exif.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seeya/core/config/app_secret.dart';
import 'package:seeya/core/config/seeya_frame_configs.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/core/utils/utils.dart';

import '../config/app_colors.dart';


class ImageUtils {

  Future<File> overlayImages(int width, int height, File backImage, File frontImage) async {

    Logger().d("overlay width ${width} , height ${height}");

    final dst = await FlutterImageCompress.compressWithFile(
      backImage.path,
      rotate: 0,
      quality: 100,
      keepExif: false,
      autoCorrectionAngle: true,
      format: CompressFormat.png,
      minWidth: width,
      minHeight: height,
    );
    final src = await FlutterImageCompress.compressWithFile(
      frontImage.path,
      rotate: 0,
      quality: 100,
      keepExif: false,
      autoCorrectionAngle: true,
      format: CompressFormat.png,
      minWidth: width,
      minHeight: height,
    );

    final optionGroup = ImageEditorOption();
    optionGroup.outputFormat = const OutputFormat.png();
    optionGroup.addOption(
      MixImageOption(
        x: 0,
        y: 0,
        width: width,// - 240,
        height: height,// - 320,
        target: MemoryImageSource(src!),
        blendMode: BlendMode.srcOver,
      ),
    );
    final result = await ImageEditor.editImage(image: dst!, imageEditorOption: optionGroup);
    File outputFile = File(backImage.path);
    await outputFile.writeAsBytes(result!);

    return outputFile;
  }


















  Future<void> fixRotateAndFlipImage(bool isFront,String path) async {
    final fixedImageFile = File(path);
    Uint8List? imageBytes = await fixedImageFile.readAsBytes();

    // flip
    if(isFront){
      final ImageEditorOption option = ImageEditorOption();
      option.addOption(const FlipOption(horizontal: true));
      // option.addOption(const RotateOption(0));
      imageBytes = await ImageEditor.editImage(image: imageBytes, imageEditorOption: option);

      if(imageBytes != null){
        await fixedImageFile.writeAsBytes(imageBytes);
      }
    }

    // rotation
    File rotatedFile = await FlutterExifRotation.rotateImage(path: fixedImageFile.path);
    Uint8List rotatedBytes = await rotatedFile.readAsBytes();
    await fixedImageFile.writeAsBytes(rotatedBytes);
    if(Platform.isIOS){
      await FileUtils.deleteFile(rotatedFile.path);
    }

  }








































  static Future<ui.Image> loadImage(Uint8List imgBytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(imgBytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  static Future<Map<String, int>> getImageDimensions(File imageFile) async {
    try {
      // 이미지 파일을 바이트로 읽어들임
      final Uint8List imgBytes = await imageFile.readAsBytes();
      // 이미지 디코딩
      final ui.Image image = await loadImage(imgBytes);
      // 이미지의 너비와 높이 반환
      return {
        'width': image.width,
        'height': image.height,
      };
    } catch (e) {
      throw Exception("이미지 크기를 가져오는 중 에러가 발생했습니다: $e");
    }
  }



}