// Profile View
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/app/modules/auth/controller/profile_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProfileController>(
        init: ProfileController(),

        builder: (controller) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFFE0E0E0),
                        child:
                            controller.user.user == null &&
                                controller.user.user?.profileImage == null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                                ),
                              )
                            : CircleAvatar(
                                radius: 50,
                                child: Icon(Icons.person, size: 50),
                              ),
                      ),
                      SizedBox(height: 20),
                      Text("Profile"),
                      Text("ChannDev@gmail.com"),
                      Text("ChannDev"),

                    ],
                  ),
                ],
              ),
              // Wrap the ListView in an Expanded widget
              Expanded(
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Card(child: ListTile(title: Text("Item $index")));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
