
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class QnaRepository extends BaseApiRepository {
  final QnaApi qnaApi;

  QnaRepository({required this.qnaApi});

  Future<CommonResponseModel> fetchQnaListApi(int queryCount, String category) async {
    return handleApiResponse(qnaApi.fetchQnaListApi(queryCount, category));
  }

}