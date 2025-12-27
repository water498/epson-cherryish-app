import 'package:get/get.dart';

class LoginController extends GetxController{

  LoginController();




  // void fetchUserData(LoginRequestModel loginRequest) async {
  //
  //   Logger().d("fetchUserData request ::: ${jsonEncode(loginRequest)}");
  //
  //   try {
  //     CommonResponseModel commonResponse = await loginRepository.callLoginApi(loginRequest.toJson());
  //
  //     if(commonResponse.successModel != null){
  //       LoginResponseModel response = LoginResponseModel.fromJson(commonResponse.successModel!.content);
  //
  //       // UserService.instance.rxUserInfo.value = response.user; //
  //       await AppPreferences().prefs?.setString(AppPrefsKeys.userAccessToken, response.access_token);
  //
  //       Get.offAndToNamed(AppRouter.root);
  //
  //     } else if(commonResponse.failModel != null) {
  //       String? reason = commonResponse.failModel!.reason;
  //       if(reason == APIFailEnum.bad_access.toDisplayString()){
  //         Get.snackbar("⚠️", '잘 못 된 접근입니다', colorText: Colors.white);
  //       }else {
  //         Get.snackbar("⚠️", '알 수 없는 오류가 발생하였습니다', colorText: Colors.white);
  //       }
  //     }
  //
  //   } catch (e, stackTrace) {
  //     Get.snackbar('An error has occurred', '[error code : ${103}]', colorText: Colors.white);
  //     Logger().d("Error: $e");
  //     Logger().d("stackTrace: $stackTrace");
  //   }
  //
  // }
  //
  //
  //
  //
  // // Apple
  // void signInWithApple() async {
  //   try {
  //     final AuthorizationCredentialAppleID credential =
  //     await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );
  //
  //     LoginRequestModel loginRequest = LoginRequestModel(
  //       name: credential.familyName ?? "unknown",
  //       email : credential.email ?? "",
  //       profile_url: null,
  //       social_type: LoginPlatform.apple.toDisplayString(),
  //       social_id: credential.userIdentifier ?? "unknown",
  //       fcm_token : AppPreferences().prefs?.getString(AppPrefsKeys.fcmToken),
  //       os_name: Platform.isIOS ? "ios" : "aos",
  //       os_version: Platform.isIOS ?  await DeviceInfoUtils.getIosInfo() : await DeviceInfoUtils.getAndroidInfo(),
  //     );
  //
  //     fetchUserData(loginRequest);
  //     AppPreferences().prefs?.setString(AppPrefsKeys.loginPlatform, LoginPlatform.apple.toDisplayString());
  //
  //   } catch (e) {
  //     Logger().e("Apple login error ${e}");
  //   }
  // }
  //
  // // Google
  // void signInWithGoogle() async {
  //   try{
  //
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //     if (googleUser != null) {
  //       final GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;
  //
  //       LoginRequestModel loginRequest = LoginRequestModel(
  //         name : googleUser.displayName ?? "unknown",
  //         email : googleUser.email,
  //         profile_url: googleUser.photoUrl,
  //         social_type: LoginPlatform.google.toDisplayString(),
  //         social_id: googleUser.id,
  //         fcm_token : AppPreferences().prefs?.getString(AppPrefsKeys.fcmToken),
  //         os_name: Platform.isIOS ? "ios" : "aos",
  //         os_version: Platform.isIOS ?  await DeviceInfoUtils.getIosInfo() : await DeviceInfoUtils.getAndroidInfo(),
  //       );
  //
  //       fetchUserData(loginRequest);
  //       AppPreferences().prefs?.setString(AppPrefsKeys.loginPlatform, LoginPlatform.google.toDisplayString());
  //
  //     }
  //   }catch (e){
  //     Logger().e("google login error ${e}");
  //   }
  //
  // }





}