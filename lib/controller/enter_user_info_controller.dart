import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../core/config/app_prefs_keys.dart';
import '../core/config/app_secret.dart';
import '../core/services/preference_service.dart';
import '../data/model/models.dart';
import '../core/services/services.dart';
import '../core/utils/utils.dart';

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











}