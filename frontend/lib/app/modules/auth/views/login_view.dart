// Create Login View
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/app/modules/auth/controller/login_controller.dart';
import 'package:social_media/app/modules/auth/views/signup_view.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      "https://m.foolcdn.com/media/dubs/original_images/Facebook-logo.png",
                      height: 200,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Welcome to Login View".toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (email) {
                              if (email == null || email.isEmpty) {
                                return "Please enter your email";
                              }
                              if (GetUtils.isEmail(email) == false) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                            obscureText: false,
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            validator: (password) {
                              if (password == null ||
                                  password.isEmpty ||
                                  password.length < 6) {
                                return "Please enter your password (at least 6 characters)";
                              }
                              return null;
                            },
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  controller.login(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              child: Obx(
                                () => controller.isLoading
                                    ? CircularProgressIndicator()
                                    : Text("Login"),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Get.to(() => SignupView());
                          },
                          child: Text("Signup"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
