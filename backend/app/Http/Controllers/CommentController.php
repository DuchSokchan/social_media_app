<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Comment;
use Illuminate\Support\Facades\Auth;
use App\Models\Post;

class CommentController extends Controller
{
    // Comment CRUD operations will be implemented here
    public function store(Request $request)
    {

        $validator = Validator::make($request->all(), [
            'comment' => 'required',
            'post_id' => 'required|exists:posts,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors()
            ], 422);
        }

        $data = $request->all();
        $user = Auth::user();

        // find the post to return with the comment
        $post = Post::find($data['post_id']);

        // if the post is found, return the comment with the post data
        if (!$post) {
            return response()->json([
                'error' => 'Post not found'
            ], 404);
        }


        // Create comment with user id and post id
        $comment = Comment::create([
            'comment' => $request->comment,
            'post_id' => $request->post_id,
            'user_id' => $user->id,
        ]);

        return response()->json([
            'message' => 'Comment created successfully',
            'comment' => $comment,
        ], 201);
    }

    // Get comments for a specific post

    public function show($postId)
    {

        // Check user and post existence before fetching comments to ensure we return appropriate error messages
        $user = Auth::user();
        $post = Post::find($postId);
        if (!$post) {
            return response()->json([
                'error' => 'Post not found'
            ], 404);
        }
        // Get comments for the post with user information
        $comments = Comment::with('user')
            ->where('post_id', $postId)
            ->latest()
            ->get();

        return response()->json([
            'comments' => $comments,
        ], 200);
    }
}
