import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../data/model/models.dart';
import '../data/repository/repositories.dart';
import '../core/services/services.dart';
import '../view/common/loading_overlay.dart';

class SettingController extends GetxController{

  final SettingRepository settingRepository;

  SettingController({required this.settingRepository});


  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPrivateUserInfo();
    });
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }



  Future<void> fetchPrivateUserInfo () async {
    try {
      CommonResponseModel commonResponse = await settingRepository.fetchMyProfile();

      if(commonResponse.successModel != null){
        UserPrivateModel response = UserPrivateModel.fromJson(commonResponse.successModel!.content['item']);

        UserService.instance.userPublicInfo.value = response.userPublicModel;
        UserService.instance.userPrivateInfo.value = response;

      }

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    } finally {

    }
  }




}