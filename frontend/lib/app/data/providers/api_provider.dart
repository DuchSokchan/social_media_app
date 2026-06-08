import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:social_media/app/data/models/login_model.dart';
import 'package:social_media/app/data/models/user_model.dart';
import 'package:social_media/app/data/models/post_model.dart';

// API Provider
class ApiProvider {
  final Dio dio = Dio();
  final box = GetStorage();
  // final baseUrlEmulator = "http://10.0.2.2:8000/api";
  final baseUrl = "http://127.0.0.1:8000/api";

  // Register User
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    File? image,
  }) async {
    try {
      final _formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        if (image != null) 'image': await MultipartFile.fromFile(image.path),
      });

      final response = await dio.post(
        "$baseUrl/register",
        data: _formData,
        options: Options(
          headers: {"Accept": "application/json"},
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception(response.data['message']);
      }
      return false;
    } catch (e) {
      throw Exception("User Already Registered");
    }
  }

  // Login User
  Future<LoginResModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // 1. FIXED: Use a standard Map instead of FormData for normal logins
      final Map<String, dynamic> loginData = {
        "email": email,
        "password": password,
      };

      final response = await dio.post(
        "$baseUrl/login",
        data: loginData, // Pass the clean map directly
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json", // Explicitly ensure JSON
          },
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        return LoginResModel.fromJson(response.data);
      } else if (response.statusCode == 401 || response.statusCode == 422) {
        // Capture validation or unauthenticated errors elegantly
        final errorMessage = response.data['message'] ?? "Invalid credentials";
        throw Exception(errorMessage);
      }
    } on DioException catch (dioError) {
      // 2. EXPOSING CORS/NETWORK BUGS: Check if the browser blocked the request
      print("Dio Error Type: ${dioError.type}");
      print("Dio Error Message: ${dioError.message}");
      print("Dio Error Response: ${dioError.response?.data}");

      if (dioError.response == null) {
        throw Exception(
          "Network/CORS error: Is your Laravel server running and allowing CORS?",
        );
      }
      throw Exception(
        dioError.response?.data['message'] ?? "Server error occurred.",
      );
    } catch (e) {
      print("Generic Catch: $e");
      throw Exception(e.toString());
    }
    throw Exception("Failed to Login");
  }

  // Get Current User
  Future<UserResModel> getcurrentUser() async {
    try {
      final token = box.read('token');

      final response = await dio.post(
        "$baseUrl/me",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      print("Response status from /me: ${response.statusCode}");
      print("Response data from /me: ${response.data}");

      if (response.statusCode == 200) {
        return UserResModel.fromJson(response.data);
      } else {
        throw Exception(
          response.data['message'] ?? "Unauthorized profile access.",
        );
      }
    } catch (e) {
      print("Error in provider parsing /me: $e");
      throw Exception(e.toString());
    }
  }

  // Get Posts
  Future<PostResModel> getPosts() async {
    try {
      final token = box.read('token');
      final response = await dio.get(
        "$baseUrl/posts",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      // print("Response status from /posts: ${response.statusCode}");
      // print("Response data from /posts: ${response.data}");

      if (response.statusCode == 200) {
        return PostResModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? "Failed to fetch posts.");
      }
    } catch (e) {
      print("Error in provider parsing /posts: $e");
      throw Exception(e.toString());
    }
  }

  // Delete Post
  Future<bool> deletePost({required int postId}) async {
    try {
      final token = box.read('token');
      final response = await dio.delete(
        "$baseUrl/posts/$postId",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      print(
        "Response status from DELETE /posts/$postId: ${response.statusCode}",
      );
      print("Response data from DELETE /posts/$postId: ${response.data}");

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.data['message'] ?? "Failed to delete post.");
      }
    } catch (e) {
      print("Error in provider parsing DELETE /posts/$postId: $e");
      throw Exception(e.toString());
    }
  }
  Future<bool> likePost({required String postId}) async {
    try {
      final token = box.read('token');
      final response = await dio.post(
        "$baseUrl/likes/dislikes/$postId",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      print(
        "Response status from POST /likes-dislikes/$postId: ${response.statusCode}",
      );
      print("Response data from POST /likes-dislikes/$postId: ${response.data}");

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.data['message'] ?? "Failed to like post.");
      }
    } catch (e) {
      print("Error in provider parsing POST /likes-dislikes/$postId: $e");
      throw Exception(e.toString());
    }
  }
}
