<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Validation\ValidationException;
use App\Models\User;
use App\Models\Post;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        try {
            $validator =  $request->validate([
                'name' => 'required',
                'email' => 'required|email|unique:users',
                'password' => 'required|min:6',
            ]);


            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'password' => bcrypt($request->password),
            ]);

            $token = $user->createToken('auth-token', expiresAt: now()->addDay(1))->plainTextToken;

            return response()->json([
                'message' => 'User registered successfully!',
                'user' => $user,
                'token' => $token
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Registration failed',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function login(Request $request)
    {
        try {
            // Validate input
            $validated = $request->validate([
                'email' => 'required|email',
                'password' => 'required|min:6',
            ]);

            // Find user
            $user = User::where('email', $validated['email'])->first();

            if (!$user) {
                return response()->json([
                    'message' => 'User not found'
                ], 404);
            }

            // Check password
            if (!Hash::check($validated['password'], $user->password)) {
                return response()->json([
                    'message' => 'Invalid email or password'
                ], 401);
            }

            // Create token
            $token = $user->createToken('auth-token')->plainTextToken;

            return response()->json([
                'message' => 'Login successful',
                'user' => $user,
                'token' => $token
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Login failed',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    public function getAllUsers(Request $request){
        try {
            $users = User::all();
            return response()->json([
                'message' => 'Users retrieved successfully',
                'users' => $users
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to retrieve users',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function logout(Request $request)
    {
        try {
            $request->user()->tokens()->delete();

            return response()->json([
                'message' => 'Logged out successfully'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Logout failed',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function update(Request $request, $id)
    {
        try {
            // 1. Find the user by the specific ID passed in the URL or request
            $user = User::findOrFail($id);

            // 2. Prepare data dynamically (only updating what is actually provided)
            $data = [
                'name' => $request->input('name'),
                'email' => $request->input('email'),
                'password' => bcrypt($request->input('password'))
            ];
            // 4. Update the user record
            $user->update($data);

            return response()->json([
                'message' => 'User updated successfully',
                'user' => $user
            ], 200);

        } catch (ModelNotFoundException $e) {
            return response()->json(['message' => 'User not found'], 404);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Update failed', 'error' => $e->getMessage()], 500);
        }
    }
    // Get current user
    public function me(Request $request)
    {
        // 1. Ensure the user is authenticated (handled by middleware)
        // 2. Return the authenticated user's information
        $user = $request->user();
        if (!$user) {
            return response()->json(['message' => 'User not authenticated'], 401);
        }
       return response()->json([
        'user' => $user
    ], 200);
    }
}

