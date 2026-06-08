// main binding
import 'package:get/get.dart';
import 'package:social_media/app/modules/main/main_controller/main_controller.dart';

class MainBinding extends Bindings {
  @override

  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
  }
}
