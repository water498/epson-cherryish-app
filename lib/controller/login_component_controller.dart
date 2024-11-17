import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login_plus/flutter_naver_login_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';
import 'package:seeya/view/common/loading_overlay.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../constants/app_prefs_keys.dart';
import '../constants/app_router.dart';
import '../data/enum/enums.dart';
import '../data/model/models.dart';
import '../data/repository/repositories.dart';
import '../service/services.dart';
import '../utils/device_info_utils.dart';

class LoginComponentController extends GetxController{

  final LoginRepository loginRepository;

  LoginComponentController({
    required this.loginRepository
  });







  void fetchUserData(LoginRequestModel loginRequest) async {

    Logger().d("fetchUserData request ::: ${jsonEncode(loginRequest)}");

    try {
      LoadingOverlay.show();

      CommonResponseModel commonResponse = await loginRepository.callLoginApi(loginRequest.toJson());

      if(commonResponse.successModel != null){
        LoginResponseModel response = LoginResponseModel.fromJson(commonResponse.successModel!.content);

        await AppPreferences().prefs?.setString(AppPrefsKeys.userAccessToken, response.access_token);
        UserService.instance.userPublicInfo.value = response.user; // access token 삽입 후 코드 진행 되어야함 => getx ever때문

        if(response.need_phone_verification){
          LoadingOverlay.hide();



          dynamic phoneVerificationResult;

          if(Get.currentRoute == AppRouter.root){
            phoneVerificationResult = await Get.toNamed(AppRouter.phone_verification);
          } else {
            phoneVerificationResult = await Get.offNamed(AppRouter.phone_verification);
          }

          if(phoneVerificationResult != "success"){
            return;
          }
        }

      } else if(commonResponse.failModel != null) {

        if(commonResponse.statusCode == 409){
          Fluttertoast.showToast(msg: "이미 가입되어 있는 이메일 주소입니다.");
        } else if(commonResponse.statusCode == 410) {
          Fluttertoast.showToast(msg: "계정이 탈퇴 처리되었습니다. 재가입은 3개월 후에 가능합니다.");
        } else if(commonResponse.statusCode == 422){
          Fluttertoast.showToast(msg: "알 수 없는 에러가 발생하였습니다. 다시 시도해주세요.");
          Logger().e("첫 로그인(가입)시에 이메일 정보가 request에 담겨있지 않음");
        }

      }

    } catch (e, stackTrace) {
      Fluttertoast.showToast(msg: "알 수 없는 에러가 발생하였습니다. 다시 시도해주세요.");
      Logger().d("Error: $e");
      Logger().d("stackTrace: $stackTrace");
    } finally {
      LoadingOverlay.hide();
    }

  }








  // Kakao
  void signInWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      try {
        isInstalled
            ? await UserApi.instance.loginWithKakaoTalk()
            : await UserApi.instance.loginWithKakaoAccount();
      } catch (e) {
        if (e is PlatformException && e.code == 'NotSupportError' && e.message != null && e.message!.contains("KakaoTalk is installed but not connected to Kakao account")) {
          // 카카오톡은 설치되어 있으나, 로그인이 되어 있지 않은 경우
          await UserApi.instance.loginWithKakaoAccount();
        } else {
          Fluttertoast.showToast(msg :"카카오톡 로그인 중 에러 발생하였습니다. [$e]");
          return;
        }
      }

      User user = await UserApi.instance.me();

      var kakaoAccount = user.kakaoAccount;

      if(kakaoAccount == null){
        Fluttertoast.showToast(msg: "카카오 계정 정보를 불러올 수 없습니다.");
        return;
      }

      LoginRequestModel loginRequest = LoginRequestModel(
        name : kakaoAccount.name,
        email : kakaoAccount.email,
        // phone: user.kakaoAccount?.phoneNumber,
        profile_url: kakaoAccount.profile?.profileImageUrl,
        social_type: LoginPlatform.kakao.toDisplayString(),
        social_id: user.id.toString(),
        fcm_token : AppPreferences().prefs?.getString(AppPrefsKeys.fcmToken),
        os_name: Platform.isIOS ? "ios" : "aos",
        os_version: Platform.isIOS ?  await DeviceInfoUtils.getIosInfo() : await DeviceInfoUtils.getAndroidInfo(),
      );

      fetchUserData(loginRequest);
      AppPreferences().prefs?.setString(AppPrefsKeys.loginPlatform, LoginPlatform.kakao.toDisplayString());

    } catch (e) {
      Logger().e("kakao login error ::: $e");
    }
  }







  // Naver
  void signInWithNaver() async {

    try{
      final NaverLoginResult result = await FlutterNaverLoginPlus.logIn();
      NaverAccessToken res = await FlutterNaverLoginPlus.currentAccessToken;

      if (result.status == NaverLoginStatus.loggedIn) {

        LoginRequestModel loginRequest = LoginRequestModel(
          name : result.account.name,
          email : result.account.email,
          // phone: result.account.mobile,
          profile_url: result.account.profileImage,
          social_type: LoginPlatform.naver.toDisplayString(),
          social_id: result.account.id,
          fcm_token : AppPreferences().prefs?.getString(AppPrefsKeys.fcmToken),
          os_name: Platform.isIOS ? "ios" : "aos",
          os_version: Platform.isIOS ?  await DeviceInfoUtils.getIosInfo() : await DeviceInfoUtils.getAndroidInfo(),
        );

        fetchUserData(loginRequest);
        AppPreferences().prefs?.setString(AppPrefsKeys.loginPlatform, LoginPlatform.naver.toDisplayString());

      }

    }catch(e){
      Logger().e("naver login error ::: $e");
    }

  }






  // Google
  void signInWithGoogle() async {
    try{

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;

        LoginRequestModel loginRequest = LoginRequestModel(
          name : googleUser.displayName,
          email : googleUser.email,
          // phone: null,
          profile_url: googleUser.photoUrl,
          social_type: LoginPlatform.google.toDisplayString(),
          social_id: googleUser.id,
          fcm_token : AppPreferences().prefs?.getString(AppPrefsKeys.fcmToken),
          os_name: Platform.isIOS ? "ios" : "aos",
          os_version: Platform.isIOS ?  await DeviceInfoUtils.getIosInfo() : await DeviceInfoUtils.getAndroidInfo(),
        );

        fetchUserData(loginRequest);
        AppPreferences().prefs?.setString(AppPrefsKeys.loginPlatform, LoginPlatform.google.toDisplayString());

      }
    }catch (e){
      Logger().e("google login error ::: $e");
    }

  }





  // Apple
  void signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID credential =
      await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      LoginRequestModel loginRequest = LoginRequestModel(
        name: credential.familyName,
        email : credential.email,
        // phone: null,
        profile_url: null,
        social_type: LoginPlatform.apple.toDisplayString(),
        social_id: credential.userIdentifier ?? "unknown",
        fcm_token : AppPreferences().prefs?.getString(AppPrefsKeys.fcmToken),
        os_name: Platform.isIOS ? "ios" : "aos",
        os_version: Platform.isIOS ?  await DeviceInfoUtils.getIosInfo() : await DeviceInfoUtils.getAndroidInfo(),
      );

      fetchUserData(loginRequest);
      AppPreferences().prefs?.setString(AppPrefsKeys.loginPlatform, LoginPlatform.apple.toDisplayString());

    } catch (e) {
      Logger().e("Apple login error ::: $e");
    }
  }








}