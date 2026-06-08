import 'package:get/get.dart';
import 'package:social_media/app/data/models/post_model.dart';
import 'package:social_media/app/data/providers/api_provider.dart';

class HomeController extends GetxController {
  var isLoading = false;
   final ApiProvider provider = ApiProvider();
   PostResModel posts =  PostResModel();
  @override
  void onInit() {
    fetchPosts();
    super.onInit();
  }
  void updateUi(bool state) {
    this.isLoading = state;
    update();
  }
  Future<void> fetchPosts() async {
    try {
      updateUi(true);
      final postData = await provider.getPosts();
      posts = postData;
      updateUi(false);
    } catch (e) {
      print("Error fetching posts: $e");
      updateUi(false);
    }
  }
  // deletePost function
  Future<void> deletePost(int postId) async {
    try {
      final success = await provider.deletePost(postId: postId);
      if (success) {
        Get.snackbar("Success", "Post deleted successfully");
        fetchPosts(); // Refresh the posts after deletion
      } else {
        Get.snackbar("Error", "Failed to delete post");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete post: $e");
    }
  }
  // like-dislike function

  Future<void> likePost(String postId, int postIndex) async {
    final postList = posts.posts?.data;
    if (postList == null || postIndex >= postList.length) return;

    final currentPost = postList[postIndex];

    // Store original values safely
    final bool originalIsLiked = currentPost.isLiked ?? false;
    final int originalLikesCount = currentPost.likeCount ?? 0;

    try {
      // Optimistic Update
      if (originalIsLiked) {
        currentPost.isLiked = false;
        currentPost.likeCount = originalLikesCount - 1;
      } else {
        currentPost.isLiked = true;
        currentPost.likeCount = originalLikesCount + 1;
      }
      update(); 

      await provider.likePost(postId: postId,);
    } catch (e) {
      // Revert changes on failure
      currentPost.isLiked = originalIsLiked;
      currentPost.likeCount = originalLikesCount;
      update(); 

      Get.snackbar(
        "Error",
        "Failed to update like status.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

}