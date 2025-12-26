import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
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
          Fluttertoast.showToast(msg: "login.toast.exist_email".tr);
        } else if(commonResponse.statusCode == 410) {
          Fluttertoast.showToast(msg: "login.toast.withdrawal".tr);
        } else if(commonResponse.statusCode == 422){
          Fluttertoast.showToast(msg: "toast.unknown_error".tr);
          Logger().e("첫 로그인(가입)시에 이메일 정보가 request에 담겨있지 않음");
        }

      }

    } catch (e, stackTrace) {
      Fluttertoast.showToast(msg: "toast.unknown_error".tr);
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
        } else if(e is PlatformException && e.message != null && e.message!.contains("canceled") ) {
          return;
        } else {
          Fluttertoast.showToast(msg :"login.toast.kakao_error01".tr);
          return;
        }
      }

      User user = await UserApi.instance.me();

      var kakaoAccount = user.kakaoAccount;

      if(kakaoAccount == null){
        Fluttertoast.showToast(msg: "login.toast.kakao_error02".tr);
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
    try {
      NaverLoginSDK.authenticate(callback: OAuthLoginCallback(
        onSuccess: () {
          // 로그인 성공 → 프로필 정보 가져오기
          NaverLoginSDK.profile(callback: ProfileCallback(
            onSuccess: (resultCode, message, response) async {
              final profile = NaverLoginProfile.fromJson(response: response);

              if (profile.id == null) {
                Logger().e("naver profile id is null");
                return;
              }

              LoginRequestModel loginRequest = LoginRequestModel(
                name: profile.name,
                email: profile.email,
                // phone: profile.mobile,
                profile_url: profile.profileImage,
                social_type: LoginPlatform.naver.toDisplayString(),
                social_id: profile.id!,
                fcm_token: AppPreferences().prefs?.getString(AppPrefsKeys.fcmToken),
                os_name: Platform.isIOS ? "ios" : "aos",
                os_version: Platform.isIOS ? await DeviceInfoUtils.getIosInfo() : await DeviceInfoUtils.getAndroidInfo(),
              );

              fetchUserData(loginRequest);
              AppPreferences().prefs?.setString(AppPrefsKeys.loginPlatform, LoginPlatform.naver.toDisplayString());
            },
            onFailure: (httpStatus, message) {
              Logger().e("naver profile failure ::: $httpStatus, $message");
            },
            onError: (errorCode, message) {
              Logger().e("naver profile error ::: $errorCode, $message");
            },
          ));
        },
        onFailure: (httpStatus, message) {
          Logger().e("naver login failure ::: $httpStatus, $message");
        },
        onError: (errorCode, message) {
          Logger().e("naver login error ::: $errorCode, $message");
        },
      ));
    } catch (e) {
      Logger().e("naver login exception ::: $e");
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