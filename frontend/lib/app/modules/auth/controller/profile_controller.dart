// Profile Controller
import 'package:get/get.dart';
import 'package:social_media/app/data/models/user_model.dart';
import 'package:social_media/app/data/providers/api_provider.dart';


class ProfileController extends GetxController {
  final ApiProvider provider = ApiProvider();
  late UserResModel user = UserResModel();
  var isLoading = false;
  void  updateUi(bool state) {
    this.isLoading = state;
    update();
  }

  Future<void> me() async {
   try {
      updateUi(true);
      final response = await provider.getcurrentUser();
      user = response;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data: $e");
    } finally {
      updateUi(false);
    }
   }
  @override
  void onInit() {
    me();
    super.onInit();
  }
}
