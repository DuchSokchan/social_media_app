import 'package:get/get.dart';
import 'package:social_media/app/data/providers/api_provider.dart';
import 'package:social_media/app/modules/main/views/main_view.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final ApiProvider provider = ApiProvider();
  final box = GetStorage();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Login Function
  Future<bool> login({required String email, required String password}) async {
    try {
      _isLoading.value = true;
      final response = await provider.login(email: email, password: password);

      if (response.token != null) {
        box.write('token', response.token);
        // box.write('user', response.user?.toJson());
        Get.snackbar(
          "Success",
          "User logged in successfully",
          snackbarStatus: (status) {
            if (status == SnackbarStatus.CLOSED) {
              Get.offAllNamed('/main');
            }
          },
        );
        return true;
      } else {
        Get.snackbar("Error", "Failed to login user");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to login user: $e");
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}
