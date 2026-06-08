<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\LikeController;
use App\Http\Controllers\CommentController;

// ============================================
// PUBLIC ROUTES - No Authentication Required
// ============================================
Route::group([], function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    Route::get('/users', [AuthController::class, 'getAllUsers']);
});

// ============================================
// PROTECTED ROUTES - Require Authentication
// ============================================
Route::middleware('auth:api')->group(function () {

    // ---- User Routes ----
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    Route::post('/me', [AuthController::class, 'me']); // New route to get current user info
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::put('/user/{id}', [AuthController::class, 'update']);

    // ---- Post Routes ----
    Route::group(['prefix' => 'posts'], function () {
        Route::post('/', [PostController::class, 'store']);
        Route::get('/', [PostController::class, 'index']);
        Route::get('/{id}', [PostController::class, 'show']);
        Route::put('/{id}', [PostController::class, 'update']);
        Route::delete('/{id}', [PostController::class, 'destroy']);
    });

    // ---- Like/Dislike Routes ----
    Route::group(['prefix' => 'likes'], function () {
        Route::post('/dislikes/{id}',[LikeController::class, 'likeDislike']);
        Route::get('/{id}', [LikeController::class, 'show']);
    });

    // ---- Comment Routes ----
    Route::group(['prefix' => 'comments'], function () {
        Route::post('/', [CommentController::class, 'store']);
        Route::get('/{id}', [CommentController::class, 'show']);
    });
});


