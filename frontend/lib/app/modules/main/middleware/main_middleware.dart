// Main Middleware
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MainMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
      if (GetStorage().read('token') == null) {
        return const RouteSettings(name: '/login');
      }
      return null;
  }
}