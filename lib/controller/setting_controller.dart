import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../data/model/models.dart';
import '../core/data/repository/auth_repository.dart';
import '../core/services/services.dart';

class SettingController extends GetxController{

  // v2 repository
  final authRepository = AuthRepository();

  SettingController();


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



  // v2 API: Fetch user profile using AuthRepository
  Future<void> fetchPrivateUserInfo () async {
    try {
      // v2: Use AuthRepository.getMe() and store directly
      final userDetail = await authRepository.getMe();
      UserService.instance.userDetail.value = userDetail;

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    }
  }




}