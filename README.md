# Sandwich Shop App

A Flutter app for ordering sandwiches. The app demonstrates a simple stateful UI with sandwich selection, quantity controls, size toggles, bread choices, and a shopping cart.

> Note: This project was scaffolded for learning/demo purposes. It focuses on UI/state handling and does not include backend persistence or payment flows.

## Key Features

- Select from a variety of sandwich types.
- View an image for each type of sandwich.
- Increment and decrement sandwich quantity.
- Toggle between six-inch and footlong sandwich sizes.
- Choose a bread type from a dropdown (e.g., white, wheat).
- Add multiple sandwiches to a shopping cart.
- View all items in the cart on a separate screen.

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

Open the app and you'll see the main order screen:

- An image of the currently selected sandwich.
- A dropdown to select the sandwich type.
- A size toggle (six-inch / footlong) implemented with a `Switch`.
- A dropdown to select bread type.
- `Add` and `Remove` buttons to change the quantity.
- An "Add to Cart" button to add the configured sandwich to your order.
- A "View Cart" button to navigate to the cart screen.

Typical flows

- Choose a sandwich: select a sandwich from the "Sandwich Type" dropdown.
- Change quantity: use the `+` and `-` buttons.
- Change size: flip the Switch between "six-inch" and "footlong".
- Change bread: select from the "Bread Type" dropdown menu.
- Add to order: press the "Add to Cart" button. A confirmation message will appear.
- View your order: press the "View Cart" button to see all items you've added.

Running tests

This repo contains a `test/` folder. Run all tests with:

```powershell
flutter test
```

## Project Structure

Top-level layout (important files/folders):

- `lib/main.dart` — The main app entry. Contains `OrderScreen` and UI widgets.
- `lib/models/sandwich.dart` — Defines the `Sandwich` data model and related enums.
- `lib/models/cart.dart` — Manages the state of the shopping cart.
- `lib/views/cart_screen.dart` — The screen that displays the contents of the shopping cart.
- `lib/views/app_styles.dart` — Shared text styles used by the UI.
- `assets/sandwiches.json` — A JSON file containing data for the available sandwiches.
- `assets/images/` — Contains the images for each sandwich.
- `pubspec.yaml` — Flutter project manifest and dependency list.
- `test/` — Unit and widget tests.

You can inspect and extend these files to add new behavior, persistence, or network-backed order submission.

## Technologies & Dependencies

- Flutter (Dart)
- Uses core Flutter widgets only (no third-party packages required).

## Known Limitations & Future Improvements

- No persistence: orders are kept in memory and lost on restart.
- No backend: there's no order submission, authentication, or payment flow.
- Basic styling: the UI is intentionally simple and intended for demonstration.

Planned / suggested improvements

- Persist orders locally (SQLite / shared_preferences).
- Add an order confirmation screen and submit to a backend API.
- Add integration tests and widget tests for UI flows.

## Contribution

Contributions are welcome. Suggested workflow:

1. Fork the repository.
2. Create a feature branch (e.g., `feature/persistent-orders`).
3. Add tests for new behavior.
4. Open a pull request describing your changes.

Please follow the existing code style and add unit tests where appropriate.

## Contact

- Owner: WoodhouseA (GitHub) — https://github.com/WoodhouseA