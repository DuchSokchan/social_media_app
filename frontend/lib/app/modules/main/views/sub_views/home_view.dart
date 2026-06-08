import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/app/modules/auth/controller/home_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final postsList = controller.posts.posts?.data ?? [];
          if (postsList.isEmpty) {
            return const Center(child: Text("No posts available."));
          }

          return RefreshIndicator(
            onRefresh: () async => await controller.fetchPosts(),
            child: ListView.builder(
              itemCount: postsList.length,
              itemBuilder: (context, index) {
                final post = postsList[index];
                final bool isLiked =
                    post.isLiked ?? false; // Safe local assignment

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. User Header Section (Cleaned redundant Column wrapper)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: const Color(0xFFE0E0E0),
                              backgroundImage: NetworkImage(
                                post.user?.profileImage ??
                                    "https://cdn-icons-png.flaticon.com/512/149/149071.png",
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.user?.name ?? "Unknown User",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    post.createdAt != null
                                        ? timeago.format(
                                            DateTime.parse(
                                              post.createdAt!,
                                            ).toLocal(),
                                          )
                                        : "Just now",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  // Handle Edit
                                } else if (value == 'delete' &&
                                    post.id != null) {
                                  controller.deletePost(post.id!);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit Post'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete Post'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 2. Post Image Section
                      Image.network(
                        post.image ?? "https://via.placeholder.com/150",
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),

                      // 3. Stats Section
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          right: 12,
                          left: 12,
                        ),
                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${post.likeCount ?? 0} likes",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "${post.commentCount ?? 0} comments",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                      Divider(height: 1, color: Colors.black.withOpacity(0.2)),

                      // 4. Interaction Bar Section
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (post.id != null) {
                                  controller.likePost(
                                    post.id!.toString(),
                                    index,
                                  );
                                }
                              },
                              child: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 22,
                                color: isLiked
                                    ? const Color.fromARGB(255, 255, 97, 202)
                                    : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.comment_outlined,
                              size: 22,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.share,
                              size: 22,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
