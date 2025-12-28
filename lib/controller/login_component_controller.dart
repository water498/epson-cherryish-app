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

import '../core/config/app_prefs_keys.dart';
import '../core/config/app_router.dart';
import '../core/data/model/auth/auth_models.dart';
import '../core/data/repository/auth_repository.dart';
import '../core/services/preference_service.dart';
import '../core/data/enum/social_login_type.dart';
import '../core/services/services.dart';
import '../core/utils/device_info_utils.dart';

class LoginComponentController extends GetxController{

  final authRepository = AuthRepository();







  void fetchUserData(LoginRequest loginRequest) async {

    Logger().d("fetchUserData request ::: ${jsonEncode(loginRequest.toJson())}");

    try {
      LoadingOverlay.show();

      LoginResponse response = await authRepository.login(loginRequest);

      // 토큰 저장
      await AppPreferences().prefs?.setString(AppPrefsKeys.userAccessToken, response.accessToken);

      // v2: Store UserDetail directly
      UserService.instance.userDetail.value = response.userInfo;

      // 전화번호 인증 필요 여부 확인
      if(response.userInfo.phoneNumberVerificationDate == null){
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
      } else {
        // 전화번호 인증이 필요 없는 경우 로그인 화면 닫기
        LoadingOverlay.hide();
        if(Get.currentRoute == AppRouter.login) {
          Get.back();
        }
      }

    } catch (e, stackTrace) {
      // Dio 에러는 DioService의 interceptor에서 처리됨
      // Fluttertoast.showToast(msg: "toast.unknown_error".tr);
      Logger().e("Login Error: $e");
      Logger().e("stackTrace: $stackTrace");
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

      LoginRequest loginRequest = LoginRequest(
        name : kakaoAccount.name,
        email : kakaoAccount.email ?? "",
        profileUrl: kakaoAccount.profile?.profileImageUrl,
        socialType: SocialLoginType.kakao,
        socialId: user.id.toString(),
        fcmToken : AppPreferences().prefs?.getString(AppPrefsKeys.fcmToken),
        osName: Platform.isIOS ? "ios" : "aos",
        osVersion: Platform.isIOS ?  await DeviceInfoUtils.getIosInfo() : await DeviceInfoUtils.getAndroidInfo(),
      );

      fetchUserData(loginRequest);
      AppPreferences().prefs?.setString(AppPrefsKeys.loginPlatform, SocialLoginType.kakao.toDisplayString());

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

              LoginRequest loginRequest = LoginRequest(
                name: profile.name,
                email: profile.email ?? "",
                profileUrl: profile.profileImage,
                socialType: SocialLoginType.naver,
                socialId: profile.id!,
                fcmToken: AppPreferences().prefs?.getString(AppPrefsKeys.fcmToken),
                osName: Platform.isIOS ? "ios" : "aos",
                osVersion: Platform.isIOS ? await DeviceInfoUtils.getIosInfo() : await DeviceInfoUtils.getAndroidInfo(),
              );

              fetchUserData(loginRequest);
              AppPreferences().prefs?.setString(AppPrefsKeys.loginPlatform, SocialLoginType.naver.toDisplayString());
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

        LoginRequest loginRequest = LoginRequest(
          name : googleUser.displayName,
          email : googleUser.email,
          profileUrl: googleUser.photoUrl,
          socialType: SocialLoginType.google,
          socialId: googleUser.id,
          fcmToken : AppPreferences().prefs?.getString(AppPrefsKeys.fcmToken),
          osName: Platform.isIOS ? "ios" : "aos",
          osVersion: Platform.isIOS ?  await DeviceInfoUtils.getIosInfo() : await DeviceInfoUtils.getAndroidInfo(),
        );

        fetchUserData(loginRequest);
        AppPreferences().prefs?.setString(AppPrefsKeys.loginPlatform, SocialLoginType.google.toDisplayString());

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

      LoginRequest loginRequest = LoginRequest(
        name: credential.familyName,
        email : credential.email ?? "",
        profileUrl: null,
        socialType: SocialLoginType.apple,
        socialId: credential.userIdentifier ?? "unknown",
        fcmToken : AppPreferences().prefs?.getString(AppPrefsKeys.fcmToken),
        osName: Platform.isIOS ? "ios" : "aos",
        osVersion: Platform.isIOS ?  await DeviceInfoUtils.getIosInfo() : await DeviceInfoUtils.getAndroidInfo(),
      );

      fetchUserData(loginRequest);
      AppPreferences().prefs?.setString(AppPrefsKeys.loginPlatform, SocialLoginType.apple.toDisplayString());

    } catch (e) {
      Logger().e("Apple login error ::: $e");
    }
  }








}