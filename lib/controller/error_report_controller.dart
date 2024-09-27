import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seeya/view/common/loading_overlay.dart';

class ErrorReportController extends GetxController{

  Rxn<File> selectedImage = Rxn<File>();


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    selectedImage.value = null;
    super.onClose();
  }


  Future<void> pickImage() async {

    try{
      var selectedXfile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(selectedXfile != null){
        selectedImage.value = File(selectedXfile.path);
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




  Future<void> uploadImage() async {

    try {
      LoadingOverlay.show(null);

      await Future.delayed(Duration(milliseconds: 500));

    } catch (e){

    } finally {
      LoadingOverlay.hide();
    }

  }





}