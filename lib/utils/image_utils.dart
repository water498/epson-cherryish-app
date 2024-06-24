import 'dart:async';
import 'dart:io';
import 'package:fc_native_image_resize/fc_native_image_resize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:gal/gal.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

import 'package:image_editor/image_editor.dart';
import 'package:logger/logger.dart';


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


















  Future<void> fixRotateAndFlipImage(String path) async {
    final fixedImageFile = File(path);
    Uint8List? imageBytes = await fixedImageFile.readAsBytes();

    // flip && rotation
    final ImageEditorOption option = ImageEditorOption();
    option.addOption(const FlipOption(horizontal: true));
    option.addOption(const RotateOption(0));
    imageBytes = await ImageEditor.editImage(image: imageBytes, imageEditorOption: option);

    if(imageBytes != null){
      await fixedImageFile.writeAsBytes(imageBytes);
    }
  }

































  // Future<File?> saveCompositeImage(List<File> images) async {
  //
  //   const frameWidth = 4000.0;
  //   const frameHeight = 6000.0;
  //
  //
  //   final recorder = ui.PictureRecorder();
  //   final canvas = Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(frameWidth, frameHeight)));
  //
  //   // 배경 색상
  //   final paint = Paint()..color = const Color(0xffffffff);
  //   canvas.drawRect(Rect.fromLTWH(0, 0, frameWidth, frameHeight), paint);
  //
  //   // 이미지 로드
  //   var backgroundAsset = "asset/image/frame_4000_6000.png";
  //   var isHane = SocketService.instance.isHaneMode.value;
  //   if(isHane){
  //     backgroundAsset = "asset/image/frame_for_hane_4000_6000.png";
  //   }
  //
  //
  //   final backgroundImage = await loadImageFromAsset(backgroundAsset);
  //   final image1 = await loadImageFromFile(images[0].path);
  //   final image2 = await loadImageFromFile(images[1].path);
  //   final image3 = await loadImageFromFile(images[2].path);
  //   final image4 = await loadImageFromFile(images[3].path);
  //
  //   // 비율을 유지하면서 이미지 크기 조정
  //   drawImage(canvas, backgroundImage, const Offset(0, 0), frameWidth, frameHeight);
  //   drawImage(canvas, image1, const Offset(frameWidth * 0.069750, frameHeight * 0.078666), frameWidth * 0.4125, frameHeight * 0.36666);
  //   drawImage(canvas, image2, const Offset(frameWidth * 0.06975, frameHeight * 0.479333), frameWidth * 0.4125, frameHeight * 0.36666);
  //   drawImage(canvas, image3, const Offset(frameWidth * 0.5175, frameHeight * 0.154), frameWidth * 0.4125, frameHeight * 0.36666);
  //   drawImage(canvas, image4, const Offset(frameWidth * 0.5175, frameHeight * 0.554666), frameWidth * 0.4125, frameHeight * 0.36666);
  //
  //   final picture = recorder.endRecording();
  //   final img = await picture.toImage(frameWidth.toInt(), frameHeight.toInt());
  //   final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  //   final buffer = byteData?.buffer.asUint8List();
  //
  //   // 파일로 저장
  //   final saveFile = File(images[3].path);
  //   if(buffer != null){
  //     await saveFile.writeAsBytes(buffer);
  //     Gal.putImage(saveFile.path);
  //
  //     return saveFile;
  //   }else {
  //     return null;
  //   }
  //
  // }

  Future<ui.Image> loadImageFromFile(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  Future<ui.Image> loadImageFromAsset(String path) async {
    final ByteData data = await rootBundle.load(path);
    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image image) {
      completer.complete(image);
    });

    return completer.future;
  }



  void drawImage(Canvas canvas, ui.Image image, Offset offset, double maxWidth, double maxHeight) {
    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();
    final aspectRatio = imageWidth / imageHeight;

    double drawWidth = maxWidth;
    double drawHeight = maxHeight;

    if (aspectRatio > 1) {
      drawHeight = drawWidth / aspectRatio;
    } else {
      drawWidth = drawHeight * aspectRatio;
    }

    final destRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      drawWidth,
      drawHeight,
    );

    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, imageWidth, imageHeight),
      destRect,
      Paint(),
    );
  }





}