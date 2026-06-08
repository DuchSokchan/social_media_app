// Create Signup View
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/app/modules/auth/controller/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  SignupView({Key? key}) : super(key: key);
  final formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final controller = Get.put(SignupController());
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
                    GetBuilder<SignupController>(
                      builder: (_) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: controller.imageBytes != null
                                      ? MemoryImage(
                                          controller.imageBytes!,
                                        ) // Web
                                      : controller.imageFile != null
                                      ? FileImage(
                                          controller.imageFile!,
                                        ) // Mobile
                                      : null,
                                  child:
                                      controller.imageBytes == null &&
                                          controller.imageFile == null
                                      ? Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),

                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.pickImage();
                                    },
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.blue,
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Welcome to Signup View".toUpperCase(),
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
                            validator: (name) {
                              if (name == null || name.isEmpty) {
                                return "Please enter your name";
                              }
                              return null;
                            },
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: "Name",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
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
                                  // Perform signup action
                                  String name = nameController.text;
                                  String email = emailController.text;
                                  String password = passwordController.text;
                                  controller.register(
                                    name: name,
                                    email: email,
                                    password: password,
                                    image: controller.imageFile,
                                  );
                                }
                              },
                              child: Text("Signup"),
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
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Get.offNamed("/login");
                          },
                          child: Text("Login"),
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
