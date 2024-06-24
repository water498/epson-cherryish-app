import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:seeya/constants/app_secret.dart';

import '../constants/app_prefs_keys.dart';
import '../data/model/models.dart';
import '../service/services.dart';

class EditorLayoutController extends GetxController{

  late PhotoTemplate photoTemplate;
  late List<PhotoLayout> photoLayouts;
  late List<PhotoFilter> photoFilters;

  var selectedLayout = Rx<PhotoLayout?>(null);
  var mergedPhotoList = <int,File?>{}.obs;
  var isUploading = false.obs;


  @override
  void onInit() {
    photoTemplate = Get.arguments['photo_template'];
    photoLayouts = Get.arguments['photo_layouts'];
    photoFilters = Get.arguments['photo_filters'];



    selectedLayout.value = photoLayouts[0];

    super.onInit();
  }





  Future<void> uploadAllMergedImages() async {

    isUploading(true);

    // for(a in ){
    //   String? result = await uploadMergedImage();
    // }
    //
    // await requestFinalMerge();

    isUploading(false);

  }

  Future<String?> uploadMergedImage(File file) async {

    try {
      var request = http.MultipartRequest("POST", Uri.parse("${AppSecret.baseUrl}/private/upload/file"));

      request.headers['api-key'] = AppSecret.apiKey;
      final token = AppPreferences().prefs?.getString(AppPrefsKeys.userAccessToken) ?? "";
      request.headers['authorization'] = 'Bearer $token';

      if(token.isEmpty){
        return null;
      }

      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields["uid"] = "";

      var response = await request.send();

      Logger().d("response code ::: ${response.statusCode}");

      if(response.statusCode >= 200 && response.statusCode < 300){
        String responseBody = await response.stream.bytesToString();
        dynamic jsonData = jsonDecode(responseBody);

        Logger().d("jsonData ::: ${jsonData}");

        String result = jsonData['result'];
        if (result == 'success') {
          return (jsonData['content']['s3_filepath'] as String);
        } else {
          return null;
        }
      }else {
        return null;
      }
    } catch (e, stackTrace) {
      Logger().e("error ::: $e");
      Logger().e("stackTrace: ${stackTrace}");
      return null;
    }

  }




  Future<void> requestFinalMerge() async{

  }


}