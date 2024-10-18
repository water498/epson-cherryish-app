import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'base_api.dart';

class QnaApi extends BaseApi {

  Future<Response> fetchQnaListApi(int queryCount, String category) async {
    return await get("/public/qna/list?page_size=$queryCount&category=$category");
  }

}