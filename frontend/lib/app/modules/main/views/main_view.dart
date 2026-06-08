import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/app/modules/main/main_controller/main_controller.dart';

class MainView extends GetView<MainController> {
  MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              controller.logout();
            },
          ),
        ],
        title: Text("Social Media App"),
      ),
      bottomNavigationBar: GetBuilder<MainController>(
        id: "bottom_navigation",
        builder: (_) => BottomNavigationBar(
          onTap: controller.onItemTapped,

          //  onTap: (index) => debugPrint(index.toString()), for debug
          currentIndex: controller.selectedIndex,

          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
      body: GetBuilder<MainController>(
        id: "index_stack",
        builder: (_) => IndexedStack(
          index: controller.selectedIndex,
          children: controller.pages,
        ),
      ),
    );
  }
}
