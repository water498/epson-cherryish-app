import 'dart:async';
import 'dart:io';
import 'package:fc_native_image_resize/fc_native_image_resize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

import 'package:image_editor/image_editor.dart';
import 'package:logger/logger.dart';
import 'package:native_exif/native_exif.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/constants/seeya_frame_configs.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/utils/utils.dart';

import '../constants/app_colors.dart';


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


  static Future<bool> checkNeedFlip(imagePath) async {
    final exif = await Exif.fromPath(imagePath);
    final orientation = await exif.getAttribute('Orientation');
    final int orientationValue = int.tryParse(orientation?.toString() ?? '1') ?? 1;  // g 피셜 1이 normal이라는데 0으로 들어오긴 함
    await exif.close();

    Logger().d("orientation ::: ${orientationValue}");

    if (orientationValue == 2 || orientationValue == 4 || orientationValue == 5 || orientationValue == 7) {
      return true;
    }else {
      return false;
    }
  }



































  static Future<File?> makeFinalFrameImage(EventFrameModel eventFrame, Map<int,CameraResultModel?> images, List<EventFilterModel> eventFilters) async {

    try{
      const frameWidth = SeeyaFrameConfigs.frameWidth;//eventFrame.width.toDouble();
      const frameHeight = SeeyaFrameConfigs.frameHeight;//eventFrame.height.toDouble();
      const filterWidth = SeeyaFrameConfigs.filterWidth;
      const filterHeight = SeeyaFrameConfigs.filterHeight;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, Rect.fromPoints(const Offset(0, 0), const Offset(frameWidth, frameHeight)));

      // 배경 색상
      final paint = Paint()..color = AppColors.blueGrey800;
      canvas.drawRect(const Rect.fromLTWH(0, 0, frameWidth, frameHeight), paint);

      // 이미지 로드
      var originalFrameImage = await DownloadUtils.loadImageFromUrl("${AppSecret.s3url}${eventFrame.original_image_filepath}");

      final image1 = await loadImageFromFile(images[0]!.file.path);
      final image2 = await loadImageFromFile(images[1]!.file.path);
      final image3 = await loadImageFromFile(images[2]!.file.path);
      final image4 = await loadImageFromFile(images[3]!.file.path);
      final frameImage = await loadImageFromFile(originalFrameImage.path);


      // 비율을 유지하면서 이미지 크기 조정
      for (int i = 0; i < eventFilters.length; i++) {

        // 하드코딩된 lt lb rt rb 값 가져옴
        final Point filterPoint = SeeyaFrameConfigs.getFilterXY(eventFrame.frame_type, eventFilters[i].type);

        drawImage(canvas,
            i == 0 ? image1 : i == 1 ? image2 : i == 2 ? image3 : image4,
            Offset(filterPoint.x.toDouble(), filterPoint.y.toDouble()),
            filterWidth, filterHeight);
      }
      drawImage(canvas, frameImage, const Offset(0, 0), frameWidth, frameHeight);

      final picture = recorder.endRecording();
      final img = await picture.toImage(frameWidth.toInt(), frameHeight.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return null;

      final buffer = byteData.buffer.asUint8List();

      // 디렉토리 경로 가져오기
      final directory = await getApplicationDocumentsDirectory();
      final resultDir = Directory("${directory.path}/result");

      // 디렉토리가 존재하지 않으면 생성
      if (!await resultDir.exists()) {
        await resultDir.create(recursive: true);
      }

      // 파일로 저장
      final saveFile = File("${resultDir.path}/result.png");
      await saveFile.writeAsBytes(buffer);

      return saveFile;
    } catch (e){
      Fluttertoast.showToast(msg: "$e");
      return null;
    }


  }

  static Future<ui.Image> loadImageFromFile(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  static Future<ui.Image> loadImageFromAsset(String path) async {
    final ByteData data = await rootBundle.load(path);
    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image image) {
      completer.complete(image);
    });

    return completer.future;
  }



  static void drawImage(Canvas canvas, ui.Image image, Offset offset, double maxWidth, double maxHeight) {
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