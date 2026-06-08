// Binding auth module

import 'package:get/get.dart';
import 'package:social_media/app/modules/auth/controller/login_controller.dart';
import 'package:social_media/app/modules/auth/controller/signup_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
    Get.lazyPut<SignupController>(
      () => SignupController(),
    );
  }
}
