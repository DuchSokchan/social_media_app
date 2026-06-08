<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Like;
use App\Models\Post;

class LikeController extends Controller
{
    // Like CRUD operations will be implemented here
    public function likeDislike(Request $request, $postId)
    {
        // Logic to like or dislike a post
        $user = Auth::user(); // Get the authenticated current user
        $post = Post::find($postId);
        if ($post != null) {
            $liked = Like::where('user_id', $user->id)->where('post_id', $postId)->first();
            if ($liked) {
                $liked->delete();
                return response()->json(['message' => 'Post unliked successfully']);
            } else {
                $like = new Like();
                $like->user_id = $user->id;
                $like->post_id = $post->id;
                $like->save();
                return response()->json(['message' => 'Post liked successfully'], 200);
            }
            return response()->json(['message' => 'Post not found'], 404);
        }
    }
    public function show($postId){
        $post = Post::find($postId);
        if ($post != null) {
            $likes = $post->likes()->with('user')->latest()->get(); // Get all likes of the post with user information
            return response()->json(['likes' => $likes ] , 200);
        }
        return response()->json(['message' => 'Like not found'], 404);
    }
}
