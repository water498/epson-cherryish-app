import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../constants/app_prefs_keys.dart';
import '../constants/app_secret.dart';
import '../data/model/models.dart';
import '../service/services.dart';
import '../utils/utils.dart';

class EnterUserInfoController extends GetxController{

  late TextEditingController nameTextController;
  late FocusNode nameFocusNode;
  late TextEditingController emailTextController;
  late FocusNode emailFocusNode = FocusNode();
  var email = "";
  var isEmailEmpty = true.obs;
  var isLoading = false.obs;
  var isDuplicatedEmail = true.obs;
  var canPass = false.obs;
  var showDuplicateView = false.obs;
  var showEmailCheckedView = false.obs;



  @override
  void onInit() {
    super.onInit();

    nameTextController = TextEditingController();
    nameFocusNode = FocusNode();
    emailTextController = TextEditingController();
    emailFocusNode = FocusNode();

    nameTextController.addListener(_nameListener);
    emailTextController.addListener(_emailListener);

    if(Get.context != null){
      // TODO if(name is empty){
      // FocusScope.of(Get.context!).requestFocus(nameFocusNode);
      //  }
      // else {
      //   FocusScope.of(Get.context!).requestFocus(emailFocusNode);
      //  }

    }

  }

  @override
  void onClose() {
    super.onClose();

    nameTextController.dispose();
    nameFocusNode.dispose();
    emailTextController.dispose();
    emailFocusNode.dispose();

    nameTextController.removeListener(_nameListener);
    emailTextController.removeListener(_emailListener);
  }


  void _nameListener(){
    canPass.value = !isDuplicatedEmail.value && nameTextController.text.isNotEmpty ? true : false;
  }


  void _emailListener() {
    if(emailTextController.text != email){
      email = emailTextController.text;
      showDuplicateView(false);
      showEmailCheckedView(false);

      isEmailEmpty.value = emailTextController.text.isEmpty ? true : false;
      canPass.value = !isDuplicatedEmail.value && nameTextController.text.isNotEmpty ? true : false;
    }
  }








  Future<void> checkDuplicate() async {

    showDuplicateView.value = true;
    // showEmailCheckedView.value = true;

    // okay
    isDuplicatedEmail.value = false;


    isEmailEmpty.value = emailTextController.text.isEmpty ? true : false;
    canPass.value = !isDuplicatedEmail.value && nameTextController.text.isNotEmpty ? true : false;

  }








  Future<void> updateUserInfo(LoginRequestModel loginRequest) async {
    final url = Uri.parse("${AppSecret.baseUrl}/public/auth/mobile/login");

    final token = AppPreferences().prefs?.getString(AppPrefsKeys.userAccessToken);
    if(token == null) return;

    try {
      isLoading.value = true;

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 실제 access token으로 대체
      };

      final body = jsonEncode({
        loginRequest
      });

      final response = await http.put(
        url,
        headers: headers,
        body: body,
      );

      Logger().d("response.statusCode ::: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        bool result = jsonResponse["success"];
        String access_token = jsonResponse["access_token"];

        Logger().d("result ::: $result access token ::: $access_token");

        if(result){

        }else {

        }

      } else {
        Fluttertoast.showToast(msg: "toast.unknown_error".tr, gravity: ToastGravity.TOP);
      }
    } finally {
      isLoading.value = false;
    }
  }



}