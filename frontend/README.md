# Social Media App (Frontend)

A modern social media application frontend built with Flutter and GetX, designed to connect with a Laravel backend API.

## Features

- **State Management & Routing**: Powered by [GetX](https://pub.dev/packages/get) for fast, reactive, and boilerplate-free state management and navigation.
- **Authentication System**: Complete Login and Registration flow with token-based authentication.
- **Route Protection**: Middleware implementation to guard authenticated routes (auto-redirects to login if no token is found).
- **Persistent Storage**: Utilizes [GetStorage](https://pub.dev/packages/get_storage) for fast and secure local storage of user sessions (tokens and user data).
- **API Integration**: RESTful API communication handled robustly using [Dio](https://pub.dev/packages/dio).

## Project Structure

This project follows a feature-first GetX pattern:
- `lib/app/modules/`: Contains all the views, controllers, and bindings for different features (Auth, Main, etc.).
- `lib/app/data/`: Houses models and API providers.
- `lib/main.dart`: Application entry point and route definitions.

## Getting Started

### Prerequisites
- Flutter SDK (latest version)
- Dart SDK
- A running instance of the Laravel backend API.

### Installation

1. **Clone the repository** (if you haven't already):
   ```bash
   git clone <repository-url>
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure API Endpoint**:
   Ensure your backend is running. Open `lib/app/data/providers/api_provider.dart` and update the `baseUrl` to match your backend's IP and port (e.g., `http://[IP_ADDRESS]/api`).

4. **Run the app**:
   ```bash
   flutter run
   ```

## Core Packages

- `get`: State management, routing, and dependency injection.
- `get_storage`: Lightweight key-value local storage.
- `dio`: Powerful HTTP client for Dart.

---
*Built with Flutter*
