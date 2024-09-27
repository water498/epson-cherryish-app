import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_router.dart';
import '../data/model/models.dart';
import '../data/repository/repositories.dart';
import '../service/services.dart';

class CustomSplashController extends GetxController{

  final CustomSplashRepository customSplashRepository;

  CustomSplashController({required this.customSplashRepository});


  @override
  void onInit() {
    super.onInit();
    _initApp();
  }

  void _initApp() async {

    await Future.delayed(const Duration(milliseconds: 300));
    await validateToken();

    Get.offNamed(AppRouter.root);

  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }



  Future<void> validateToken() async {
    try {
      CommonResponseModel commonResponse = await customSplashRepository.validateTokenApi();

      if(commonResponse.successModel != null){
        ValidateTokenResponseModel response = ValidateTokenResponseModel.fromJson(commonResponse.successModel!.content);

        if(response.success){
          UserService.instance.userInfo.value = response.user;
        }

      }

    } catch (e, stackTrace) {
      Logger().d("Error: $e");
      Logger().d("stackTrace: $stackTrace");
    } finally {

    }
  }



}