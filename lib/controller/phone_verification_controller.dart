import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/data/repository/repositories.dart';
import 'package:seeya/view/common/loading_overlay.dart';

import '../data/model/models.dart';

class PhoneVerificationController extends GetxController{

  final PhoneVerificationRepository phoneVerificationRepository;

  PhoneVerificationController({required this.phoneVerificationRepository});



  late FocusNode phoneFocusNode;
  late TextEditingController phoneTextController;
  late FocusNode codeFocusNode;
  late TextEditingController codeTextController;

  FirebaseAuth auth = FirebaseAuth.instance;

  var showVerifyCodeWidget = false.obs;
  var isPhoneEmpty = true.obs;

  String countryCode = "+82";
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
    phoneFocusNode.dispose();
    codeFocusNode.dispose();
    phoneTextController.dispose();
    codeTextController.dispose();
    phoneTextController.removeListener(_phoneListener);
    super.onClose();
  }



  void _phoneListener(){
    isPhoneEmpty.value = phoneTextController.value.text.length < 9;
  }


  verifyPhoneNumber(String phoneNumber) async {

    stopTimer();
    showVerifyCodeWidget(false);
    String fullPhoneNumber = "$countryCode${int.parse(phoneNumber).toString()}";
    latestPhoneNumber = fullPhoneNumber;

    Logger().d("fullPhoneNumber ::: ${fullPhoneNumber}");


    await auth.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      timeout: Duration(seconds: timeoutSeconds),
      verificationCompleted: (phoneAuthCredential) async {

        handleVerificationCompleted(phoneAuthCredential);

      },
      verificationFailed: (e) {
        stopTimer();
        Logger().e("verificationFailed!!! check auth : error : ${e.code} ${e.message} ${e.stackTrace}");
        if (e.code.contains("captcha-check-failed")) {
          Fluttertoast.showToast(msg: "reCAPTCHA 인증에 실패하였습니다.",gravity: ToastGravity.TOP);
        } else if(e.code.contains("invalid-phone-number")) {
          Fluttertoast.showToast(msg: "잘못된 전화번호입니다.",gravity: ToastGravity.TOP);
        } else if(e.code.contains("quota-exceeded")){
          Fluttertoast.showToast(msg: "오늘의 인증 요청 제한을 초과했습니다. 나중에 다시 시도해주세요.",gravity: ToastGravity.TOP);
        } else if(e.code.contains("web-context-cancelled")){

        } else {
          Fluttertoast.showToast(msg: "인증에 실패했습니다. 오류 코드 : ${e.code}",gravity: ToastGravity.TOP);
        }

      },
      codeSent: (verificationId, forceResendingToken) async {
        showVerifyCodeWidget(true);
        _verificationId = verificationId;
        startTimer();
      },
      codeAutoRetrievalTimeout: (verificationId) {
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
      LoadingOverlay.show(null);

      UserCredential userCredential = await auth.signInWithCredential(credential);
      String finalPhoneNumber = userCredential.user?.phoneNumber ?? latestPhoneNumber;
      await updateUserPhoneVerification(finalPhoneNumber);

    } catch (e){
      Logger().e("signInWithCredential fail  error ::: [${e}]");
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-verification-code':
            Fluttertoast.showToast(msg: "인증번호를 다시 확인해주세요.",gravity: ToastGravity.TOP);
            break;
          case 'session-expired':
            Fluttertoast.showToast(msg: "인증번호 입력 시간이 만료되었습니다.",gravity: ToastGravity.TOP);
            break;
          case 'quota-exceeded':
            Fluttertoast.showToast(msg: "오늘의 인증 요청 제한을 초과했습니다. 나중에 다시 시도해주세요.",gravity: ToastGravity.TOP);
            break;
          case 'too-many-requests':
            Fluttertoast.showToast(msg: "너무 많은 요청을 보냈습니다. 잠시 후 다시 시도해주세요.",gravity: ToastGravity.TOP);
            break;
          case 'network-request-failed':
            Fluttertoast.showToast(msg: "네트워크 연결에 문제가 발생했습니다.",gravity: ToastGravity.TOP);
            break;
          case 'invalid-phone-number':
            Fluttertoast.showToast(msg: "잘못된 전화번호 형식입니다.",gravity: ToastGravity.TOP);
            break;
          default:
            Fluttertoast.showToast(msg: "인증에 실패했습니다. 오류 코드 : ${e.code}",gravity: ToastGravity.TOP);
        }
      } else {
        Logger().e("signInWithCredential fail error ::: [${e.toString()}]");
        Fluttertoast.showToast(msg: "알 수 없는 오류가 발생했습니다. 다시 시도해주세요.",gravity: ToastGravity.TOP);
      }
    } finally {
      LoadingOverlay.hide();
    }
  }




  onButtonClick(BuildContext context) async {
    if(timer == null && !showVerifyCodeWidget.value){
      // 인증번호 받기
      var phoneNumber = phoneTextController.value.text;
      await verifyPhoneNumber(phoneNumber);
    }else {
      // 다음
      if(codeTextController.value.text.length != 6){
        Fluttertoast.showToast(msg: "인증 번호 6자리를 모두 입력해주세요.",gravity: ToastGravity.TOP);
        return;
      }
      verifySMSCode(codeTextController.value.text);
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
    if(showToast) Fluttertoast.showToast(msg: "인증 시간이 만료되었습니다. 다시 시도해주세요.",gravity: ToastGravity.TOP);
    showVerifyCodeWidget(false);
  }



  Future<void> updateUserPhoneVerification(String fullPhoneNumber) async {
    try {

      Map<String, dynamic> request = {
        "phone_number" : fullPhoneNumber
      };

      CommonResponseModel commonResponse = await phoneVerificationRepository.phoneVerificationApi(request);

      if(commonResponse.successModel != null){

        // TODO reponse(user model) 로 user update 처리

        stopTimer();
        Get.back(result: {"result" : "success"});

      } else if(commonResponse.failModel != null) {

        if(commonResponse.statusCode == 422){
          Fluttertoast.showToast(msg: "알 수 없는 에러가 발생하였습니다. 다시 시도해주세요.");
          Logger().e("phoneVerificationApi request parameter error");
        }

      }




    } catch (e, stackTrace) {
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
      rethrow;
    } finally {

    }
  }






}