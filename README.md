# Sandwich Shop App

A Flutter app for ordering sandwiches. The app demonstrates a stateful UI with sandwich selection, cart management, local persistence, and user settings.

> Note: This project was scaffolded for learning/demo purposes.

## Key Features

- **Sandwich Customization**: Select sandwich type, size (six-inch/footlong), bread type, and quantity.
- **Shopping Cart**: Add multiple items to a cart, view cart contents, and proceed to checkout.
- **Order History**: Persist placed orders locally using SQLite and view past order details.
- **Settings**: Customize app appearance (e.g., font size) with preferences saved locally.
- **Responsive Design**: Adaptive UI for different screen sizes.
- **Firebase Integration**: Initialized for future backend capabilities.

## Installation & Setup

Prerequisites

- Flutter SDK (>= stable channel). See: https://flutter.dev/docs/get-started/install
- Platform tools for your target (Android SDK, Xcode for iOS, or desktop toolchains for Windows/macOS/Linux).
- Git

Clone the repository

```powershell
git clone https://github.com/WoodhouseA/sandwich_shop.git
cd sandwich_shop
```

Install dependencies

```powershell
flutter pub get
```

Run the app

- Run on an available device (Android emulator, iOS simulator, or desktop):

```powershell
flutter run
```

## How to Use

1.  **Order**: Customize your sandwich on the main screen and add it to the cart.
2.  **Cart**: View your selected items in the cart screen.
3.  **Checkout**: Finalize your order. This saves the order to your local history.
4.  **History**: View your past orders in the Order History screen.
5.  **Settings**: Adjust font size in the Settings screen.

Running tests

This repo contains a `test/` folder. Run all tests with:

```powershell
flutter test
```

## Project Structure

Top-level layout (important files/folders):

- `lib/main.dart` — App entry point, initializes Firebase and SQLite.
- `lib/models/` — Data models (`Sandwich`, `Cart`, `SavedOrder`).
- `lib/views/` — UI Screens:
    - `order_screen.dart`: Main ordering interface.
    - `cart_screen.dart`: Shopping cart view.
    - `checkout_screen.dart`: Order finalization.
    - `order_history_screen.dart`: List of past orders.
    - `settings_screen.dart`: User preferences.
- `lib/services/database_service.dart` — SQLite database management for storing orders.
- `lib/repositories/` — Data repositories (e.g., `pricing_repository.dart`).
- `lib/widgets/` — Reusable UI components.
- `assets/` — Images and data files.

## Technologies & Dependencies

- **Flutter (Dart)**
- **Provider**: State management.
- **SQLite (sqflite)**: Local database for order history.
- **Shared Preferences**: Persisting user settings.
- **Firebase Core**: App initialization.

## Known Limitations & Future Improvements

- **Backend**: Currently uses local storage. Syncing with a remote server is a planned improvement.
- **Auth**: User authentication is not yet implemented.

## Contact

- Owner: WoodhouseA (GitHub) — https://github.com/WoodhouseA