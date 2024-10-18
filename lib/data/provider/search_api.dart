import 'package:get/get.dart';
import 'base_api.dart';

class SearchApi extends BaseApi {

  Future<Response> searchEventsFromKeywordApi(String keyword) async {
    return await get("/mobile/search/keyword/list?keyword=$keyword");
  }

}