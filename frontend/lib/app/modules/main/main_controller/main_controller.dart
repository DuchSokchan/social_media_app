// main controller
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:social_media/app/modules/main/views/sub_views/home_view.dart';
import 'package:social_media/app/modules/main/views/sub_views/profile_view.dart';
import 'package:social_media/app/modules/main/views/sub_views/search_view.dart';
import 'package:social_media/app/modules/main/views/sub_views/setting_view.dart';

class MainController extends GetxController {
  final box = GetStorage();

  var selectedIndex = 0;

  void onItemTapped(int index) {
    selectedIndex = index;
    update(['index_stack', 'bottom_navigation']);
  }

  var pages = [
    HomeView(),
    SearchView(),
    SettingView(),
    ProfileView(),
  ];

  // logout function
  Future<void> logout() async {
    await box.remove('token');
    Get.offAllNamed('/login');
  }
}
