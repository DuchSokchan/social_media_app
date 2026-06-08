import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:social_media/app/modules/auth/bindings/auth_binding.dart';
import 'package:social_media/app/modules/auth/views/login_view.dart';
import 'package:social_media/app/modules/auth/views/signup_view.dart';
import 'package:social_media/app/modules/main/main_binding/main_binding.dart';
import 'package:social_media/app/modules/main/views/main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // 1. Read the token directly before building the app
  final box = GetStorage();
  final String initialRoute = box.read('token') != null ? "/main" : "/login";

  // 2. Pass the determined initial route into the app
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // 3. Set the initial route dynamically
      initialRoute: initialRoute,
      getPages: [
        GetPage(
          name: "/login",
          page: () => LoginView(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: "/signup",
          page: () => SignupView(),
          binding: AuthBinding(),
        ),
        GetPage(name: "/main", page: () => MainView(), binding: MainBinding()),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Social Media App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
