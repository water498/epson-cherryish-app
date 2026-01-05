import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/config/app_router.dart';
import 'package:seeya/core/data/model/auth/auth_models.dart';
import 'package:seeya/core/data/repository/auth_repository.dart';
import 'package:seeya/core/services/services.dart';
import 'package:seeya/core/utils/utils.dart';
import 'package:seeya/view/common/loading_overlay.dart';

import '../data/model/models.dart';

class PhoneVerificationController extends GetxController{

  final authRepository = AuthRepository();



  late FocusNode phoneFocusNode;
  late TextEditingController phoneTextController;
  late FocusNode codeFocusNode;
  late TextEditingController codeTextController;

  FirebaseAuth auth = FirebaseAuth.instance;

  var showVerifyCodeWidget = false.obs;
  var isPhoneEmpty = true.obs;
  var isLoading = false.obs; // 중복 클릭 방지용

  // String countryCode = "+82";
  String isoCode = "KR"; // 국가 코드
  String latestPhoneNumber = "";
  String _verificationId = '';
  Timer? timer;
  static var timeoutSeconds = 120;
  var timeRemaining = timeoutSeconds.obs;
  var isTimeExpired = false.obs;
  var disableTextField = false.obs;





  @override
  void onInit() {
    phoneFocusNode = FocusNode();
    codeFocusNode = FocusNode();
    phoneTextController = TextEditingController();
    codeTextController = TextEditingController();
    phoneTextController.addListener(_phoneListener);
    ever(showVerifyCodeWidget, (bool showCodeTextField) {
      if(showCodeTextField){
        disableTextField(true);
        codeTextController.text = "";
        if(Get.context != null) {
          FocusScope.of(Get.context!).requestFocus(codeFocusNode);
        }
      }else {
        disableTextField(false);
        setDelayedFocus ();
      }
    });
    super.onInit();
  }

  setDelayedFocus () async {
    if(Get.context != null) {
      await Future.delayed(const Duration(milliseconds: 300));
      FocusScope.of(Get.context!).requestFocus(phoneFocusNode);
    }
  }

  @override
  void onClose() {
    stopTimer();
    phoneTextController.removeListener(_phoneListener);
    phoneFocusNode.dispose();
    codeFocusNode.dispose();
    phoneTextController.dispose();
    codeTextController.dispose();
    super.onClose();
  }



  void _phoneListener(){
    isPhoneEmpty.value = phoneTextController.value.text.length < 9;
  }


  verifyPhoneNumber(String phoneNumber) async {

    phoneFocusNode.unfocus();
    stopTimer();
    showVerifyCodeWidget(false);
    String? fullPhoneNumber = await FormatUtils.getFormattedPhoneNumber(isoCode: isoCode,rawPhoneNumber: phoneNumber);
    if(fullPhoneNumber == null){
      Fluttertoast.showToast(msg: "phone_verification.toast.invalid_phone".tr);
      return;
    }
    latestPhoneNumber = fullPhoneNumber;

    Logger().d("fullPhoneNumber ::: ${fullPhoneNumber}");


    LoadingOverlay.show();

    await auth.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      timeout: Duration(seconds: timeoutSeconds),
      verificationCompleted: (phoneAuthCredential) async {

        LoadingOverlay.hide();
        handleVerificationCompleted(phoneAuthCredential);

      },
      verificationFailed: (e) {
        LoadingOverlay.hide();
        stopTimer();
        Logger().e("verificationFailed!!! check auth : error : ${e.code} ${e.message} ${e.stackTrace}");
        if (e.code.contains("captcha-check-failed")) {
          Fluttertoast.showToast(msg: "phone_verification.toast.recaptcha".tr,gravity: ToastGravity.TOP);
        } else if(e.code.contains("invalid-phone-number")) {
          Fluttertoast.showToast(msg: "phone_verification.toast.invalid_phone".tr,gravity: ToastGravity.TOP);
        } else if(e.code.contains("quota-exceeded")){
          Fluttertoast.showToast(msg: "phone_verification.toast.quota".tr,gravity: ToastGravity.TOP);
        } else if(e.code.contains("web-context-cancelled")){
          // 사용자가 reCAPTCHA를 취소한 경우 - 에러 메시지 없이 조용히 처리
        } else {
          Fluttertoast.showToast(msg: "phone_verification.toast.error".tr,gravity: ToastGravity.TOP);
        }

      },
      codeSent: (verificationId, forceResendingToken) async {
        LoadingOverlay.hide();
        showVerifyCodeWidget(true);
        _verificationId = verificationId;
        startTimer();
      },
      codeAutoRetrievalTimeout: (verificationId) {
        LoadingOverlay.hide();
        Logger().d("codeAutoRetrievalTimeout!!! verificationId ::: $verificationId");
        // 시간 초과 시 호출됩니다.
        _verificationId = verificationId;
        stopTimer();
        if(isClosed) return;
        // Handle code retrieval timeout

      },
    );
  }


  // 인증번호 입력 후 인증 처리
  Future<void> verifySMSCode(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );

      handleVerificationCompleted(credential);
      // 인증 성공
    } catch (e) {
      Logger().e('인증 실패: $e');
    }
  }



  handleVerificationCompleted(PhoneAuthCredential credential) async {
    try{
      LoadingOverlay.show();

      UserCredential userCredential = await auth.signInWithCredential(credential);
      String finalPhoneNumber = userCredential.user?.phoneNumber ?? latestPhoneNumber;
      await updateUserPhoneVerification(finalPhoneNumber);

    } catch (e){
      Logger().e("signInWithCredential fail  error ::: [${e}]");
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-verification-code':
            Fluttertoast.showToast(msg: "phone_verification.toast.invalid_code".tr,gravity: ToastGravity.TOP);
            break;
          case 'session-expired':
            Fluttertoast.showToast(msg: "phone_verification.toast.code_expired".tr,gravity: ToastGravity.TOP);
            break;
          case 'quota-exceeded':
            Fluttertoast.showToast(msg: "phone_verification.toast.quota_exceeded".tr,gravity: ToastGravity.TOP);
            break;
          case 'too-many-requests':
            Fluttertoast.showToast(msg: "phone_verification.toast.too_many".tr,gravity: ToastGravity.TOP);
            break;
          case 'network-request-failed':
            Fluttertoast.showToast(msg: "phone_verification.toast.network".tr,gravity: ToastGravity.TOP);
            break;
          case 'invalid-phone-number':
            Fluttertoast.showToast(msg: "phone_verification.toast.invalid_phone".tr,gravity: ToastGravity.TOP);
            break;
          default:
            Fluttertoast.showToast(msg: "phone_verification.toast.error".tr,gravity: ToastGravity.TOP);
        }
      } else {
        Logger().e("signInWithCredential fail error ::: [${e.toString()}]");
        Fluttertoast.showToast(msg: "toast.unknown_error".tr,gravity: ToastGravity.TOP);
      }
    } finally {
      LoadingOverlay.hide();
    }
  }




  onButtonClick(BuildContext context) async {
    // 중복 클릭 방지
    if (isLoading.value) return;

    if(timer == null && !showVerifyCodeWidget.value){
      // 인증번호 받기
      var phoneNumber = phoneTextController.value.text;
      await verifyPhoneNumber(phoneNumber);
    }else {
      // 다음
      if(codeTextController.value.text.length != 6){
        Fluttertoast.showToast(msg: "phone_verification.toast.code_short".tr,gravity: ToastGravity.TOP);
        return;
      }
      isLoading.value = true;
      await verifySMSCode(codeTextController.value.text);
      isLoading.value = false;
    }

  }











  void startTimer() {
    timeRemaining.value = timeoutSeconds;
    isTimeExpired.value = false;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (timeRemaining > 0) {
        timeRemaining--;
      } else {
        reset(true);
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }


  void reset(bool showToast){
    isTimeExpired.value = true;
    stopTimer();
    if(showToast) Fluttertoast.showToast(msg: "phone_verification.toast.code_expired_retry".tr,gravity: ToastGravity.TOP);
    showVerifyCodeWidget(false);
    // 모든 필드 초기화
    codeTextController.text = "";
    phoneTextController.text = "";
    _verificationId = "";
  }



  Future<void> updateUserPhoneVerification(String fullPhoneNumber) async {
    try {

      PhoneVerifyRequest request = PhoneVerifyRequest(phoneNumber: fullPhoneNumber);

      UserDetail response = await authRepository.verifyPhone(request);

      // v2: Store UserDetail directly
      UserService.instance.userDetail.value = response;

      stopTimer();
      Get.back(result: "success");

    } catch (e, stackTrace) {
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
      // Fluttertoast.showToast(msg: "toast.unknown_error".tr);
      // 서버 에러 발생 시 타이머 중지 및 UI 리셋
      stopTimer();
      reset(false);
    } finally {

    }
  }






}