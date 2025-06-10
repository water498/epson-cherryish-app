import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/constants/seeya_frame_configs.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/view/common/loading_overlay.dart';

import '../utils/file_utils.dart';
import '../utils/image_utils.dart';

class CameraScreenController extends GetxController{

  // camera
  CameraController? cameraController;
  late List<CameraDescription> descriptions;

  // timer
  var timerCarouselController = CarouselSliderController();
  var isTimerIconAnimating = false;
  var isTimerCounting = false.obs;
  var timerSecondList = [0,5,10]; // 0,3,10
  var timerSecondIndex = 1;
  RxInt countdown = 0.obs;
  Timer? timer;

  // state
  var isInitialized = false.obs;
  var showFlashAnim = false.obs;
  var showImage = false.obs;
  var isImgProcessing = false.obs;

  // image files
  File? currentMergedImageFile;

  // gallery image
  Rx<Uint8List?> latestPhoto = Rx<Uint8List?>(null);
  ValueChanged<MethodCall>? galleryListener;

  // controller
  final frameController = Get.find<DecorateFrameController>();

  // inner filter pageview
  late PageController pageController;
  var currentPage = 0.obs;
  late EventFilterModel currentFilter;


  @override
  void onInit() {

    currentPage.value = Get.arguments["selected_index"];
    currentFilter = frameController.eventFilterList[currentPage.value];

    pageController = PageController(
      initialPage: currentPage.value,
      viewportFraction: 0.2,
    );
    pageController.addListener(pageListener);

    initWithAwait();
    super.onInit();
  }

  @override
  void onClose() {
    if(galleryListener != null){
      PhotoManager.removeChangeCallback(galleryListener!);
    }
    stopTimer();
    pageController.removeListener(pageListener);
    pageController.dispose();
    cameraController?.dispose();
    cameraController = null;
    latestPhoto.value = null;
    super.onClose();
  }





  Future<void> initWithAwait() async {
    await initCamera();
    await startWatchingRecentImage();
  }



  void pageListener(){
    if(pageController.page != null){
      currentPage.value = pageController.page!.round();
      currentFilter = frameController.eventFilterList[currentPage.value];
    }
  }






  void startFlashAnim() {
    showFlashAnim.value = true;
    Future.delayed(Duration(seconds: 1), () {
      showFlashAnim.value = false;
    });
  }

  void startTimer() {
    countdown.value = timerSecondList[timerSecondIndex];
    timer?.cancel();
    isTimerCounting(true); // 타이머 텍스트 활성

    if (countdown.value == 0) {
      isTimerCounting(false);
      takePicture(currentPage.value);
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdown.value > 1) {
          countdown.value--;
        } else {
          stopTimer();
          takePicture(currentPage.value); // 타이머 종료 후 사진 찍기 함수 호출
        }
      });
    }
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
    isTimerCounting(false);
  }




  Future<void> initCamera() async {

    PermissionStatus cameraPermissionStatus = await Permission.camera.request();
    if(cameraPermissionStatus.isDenied){
      Fluttertoast.showToast(msg: "camera.toast.allow_permission".tr);
      Get.back();
      return;
    }


    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }



    try {
      // 사용 가능한 카메라 확인
      descriptions = await availableCameras();

      if (descriptions.isEmpty) {
        throw ("사용 가능한 카메라가 없습니다.");
      }

      // 카메라 컨트롤러 초기화
      cameraController = CameraController(
        descriptions[1], // descriptions[1] 대신 descriptions의 인덱스를 안전하게 선택해야 함
        ResolutionPreset.ultraHigh,
        enableAudio: false,
      );

      await cameraController?.initialize();
      cameraController?.setFlashMode(FlashMode.off);
      isInitialized(true);

    } catch (e) {
      // Camera initialization error
      if (e is CameraException) {
        if(e.code.contains("CameraAccessDenied")){
          Fluttertoast.showToast(msg: "camera.toast.allow_permission".tr);
          await Future.delayed(const Duration(milliseconds: 600));
          openAppSettings();
        }else {
          Fluttertoast.showToast(msg: "camera.toast.init_error".tr);
        }
      }else {
        Fluttertoast.showToast(msg: "camera.toast.init_error".tr);
      }

    }

  }




  Future<void> startWatchingRecentImage() async {
    PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        androidPermission: AndroidPermission(type: RequestType.image, mediaLocation: true),
      ),
    ).then((ps) {
      if (ps.isAuth) {

        // 초기 최신 사진 제공
        _updateLatestPhoto();

        // 리스너 추가
        galleryListener = (value) {
          _updateLatestPhoto();
        };

        // 갤러리 변경 감지 콜백 설정
        PhotoManager.addChangeCallback(galleryListener!);

        // 권한 감지
        PhotoManager.startChangeNotify();
      }
    });

  }





  Future<void> _updateLatestPhoto() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    if (albums.isNotEmpty) {
      List<AssetEntity> photos = await albums.first.getAssetListRange(start: 0, end: 1);
      if (photos.isNotEmpty) {
        latestPhoto.value = await photos.first.thumbnailDataWithSize(const ThumbnailSize(200, 200));
      } else {
        latestPhoto.value = null;
      }
    }
  }


  Future<File?> takePicture(int index) async {
    if(cameraController == null){
      return null;
    }
    if (!cameraController!.value.isInitialized) {
      return null;
    }

    XFile? capturedFile;
    File? tempFile;

    try {

      var filter = frameController.eventFilterList[index];

      LoadingOverlay.show();

      startFlashAnim();

      isImgProcessing(true);
      capturedFile = await cameraController!.takePicture(); // temp directory
      tempFile = File(capturedFile.path); // document direcotry


      var ratio = SeeyaFrameConfigs.filterHeight / SeeyaFrameConfigs.filterWidth;

      // fit & rotate
      LoadingOverlay.show("loading.overlay01".tr);
      bool isFront = cameraController!.description.lensDirection == CameraLensDirection.front;
      await ImageUtils().fixRotateAndFlipImage(isFront, tempFile.path);

      // picture image properties
      ImageProperties properties = await FlutterNativeImage.getImageProperties(tempFile.path);
      var width = properties.width!;
      var height = properties.height!;
      Logger().d("temp file 즉 원본이미지 - orientation ::: ${properties.orientation} width ::: ${width} height :::: ${height}");


      double targetHeight = width * (ratio);
      int offsetX = 0;
      int offsetY = (height - targetHeight) ~/ 2;

      LoadingOverlay.show("loading.overlay02".tr);
      final croppedUserImageFile = await FlutterNativeImage.cropImage(tempFile.path, offsetX, offsetY, width, (width*(ratio)).toInt());
      await croppedUserImageFile.copy(tempFile.path);
      FileUtils.deleteFile(croppedUserImageFile.path);


      if(filter.image_filepath != null){
        LoadingOverlay.show("loading.overlay03".tr);
        final overlayImage = await FileUtils.findFileFromUrl("${AppSecret.s3url}${filter.image_filepath}");
        await ImageUtils().overlayImages(width, (width*(ratio)).toInt(), tempFile, overlayImage);
      }

      var model = CameraResultModel(filter_uid: filter.uid, file: tempFile);
      frameController.mergedPhotoList[index] = model;

      return File(tempFile.path);

    } catch (e, s) {
      isImgProcessing(false);
      Logger().e('Error taking picture: $e');
      Logger().e('Error taking picture: s::: $s');
      Fluttertoast.showToast(msg: "e ::: $e",toastLength: Toast.LENGTH_LONG);
      return null;
    } finally {
      LoadingOverlay.hide();
    }
  }



  Future<XFile?> pickImage() async {
    XFile? selectedImage;
    try{
      selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(selectedImage != null){
        return selectedImage;
      }else {
        return null;
      }

    }catch (e){
      if(Platform.isIOS){
        var status = await Permission.photos.status;
        if (status.isDenied) {
          Logger().d('Access Denied');
          openAppSettings();
        } else {
          Logger().e('Exception occured! ::: $e');
        }
      }
      return null;
    }

  }



  void switchingCamera(){
    if (cameraController?.description.lensDirection == CameraLensDirection.back) {
      cameraController?.setDescription(descriptions[1]);
    } else {
      cameraController?.setDescription(descriptions[0]);
    }
  }




  Future<void> deleteImageFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      Logger().e("Failed to delete file: $e");
    }
  }

}