import 'package:get/get.dart';
import 'package:seeya/data/provider/providers.dart';

import '../controller/controllers.dart';
import '../data/repository/repositories.dart';

class EditorLayoutBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<EditorLayoutController>(() => EditorLayoutController());
  }

}