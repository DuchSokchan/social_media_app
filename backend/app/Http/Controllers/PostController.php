<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Post;
use App\Models\Comment;

class PostController extends Controller
{
    // CRUD Post operations will be implemented here
    public function store(Request $request)
    {
        // Validate and create a new post
        $data = $request->all();
        $user = Auth::user();

        if ($user != null ){
            if ($request->hasFile('image')) {
                $image = $request->file('image');
                $name = time() . '_' . $image->getClientOriginalName();
                $destinationPath = public_path('/posts');
                $image->move($destinationPath, $name);
                $data['image'] = $name;
            }
            $data['user_id'] = $user->id;
            $post = Post::create($data);
            $post = Post::with('user')->find($post->id);
            $message = 'Post created successfully';
            return response()->json(['post' => $post, 'message' => $message], 201);
        }
    }

    // Get all posts
    public function index(Request $request)
    {
        // Return a list of posts
        $user = Auth::user();
        $posts = Post::with('user', 'likes' , 'comments')->latest()->paginate(10);

        foreach ($posts as $post) {
            $post->like_count = $post->likes()->count();
            $post->comment_count = $post->comments()->count();
            $post->isLiked = $post->likes->contains('user_id', Auth::id());

        }

        return response()->json(['posts' => $posts], 200);

    }

    public function show($id)
    {
        // Return a single post
        // Requesting user (if authenticated) to check like status
        $user = Auth::user();
        // Load relationships + counts
        $post = Post::with('user')->find($id);
        if($post != null){
            $post->like_count = $post->likes()->count();
            $post->comment_count = $post->comments()->count();
            $post->isLiked = $post->likes->contains('user_id', Auth::id());
        }

        // More efficient way to check like full collection)
        $isLiked = $user
            ? $post->likes->contains('user_id', $user->id)
            : false;

        return response()->json([
            'post' => $post,
        ], 200);
    }

    public function update(Request $request, Post $post)
    {
        // Validate and update the post
        $data = $request->all();
        $user = Auth::user();
        if ($user != null){
            if ($post->user_id == $user->id){
                if ($request->hasFile('image')) {
                    $image = $request->file('image');
                    $name = time() . '_' . $image->getClientOriginalName();
                    $destinationPath = public_path('/posts');
                    $image->move($destinationPath, $name);
                    $data['image'] = $name;
                    $oldImage = $post->image;
                    if ($oldImage) {
                        $path = public_path('/posts/' . $oldImage);
                        if (file_exists($path)) {
                            unlink($path);
                        }
                    }
                }
                $post->update($data);
                return response()->json(['post' => $post, 'message' => 'Post updated successfully'], 200);
            } else {
                return response()->json(['message' => 'Unauthorized'], 403);
            }
        }
    }

    public function destroy($id)
    {
        // Delete the post
        $user = Auth::user();
        $post = Post::find($id);
        if ($user != null){
            if ($post->user_id == $user->id){
                $post->delete();
                return response()->json(['message' => 'Post deleted successfully'], 200);
            } else {
                return response()->json(['message' => 'Unauthorized'], 403);
            }
        }

    }
}
