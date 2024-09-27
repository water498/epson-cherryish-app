import 'package:get/get.dart';
import 'package:seeya/controller/controllers.dart';

class ImageListViewerBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<ImageListViewerController>(() => ImageListViewerController());
  }

}