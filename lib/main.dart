import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/auth_screen.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Cart _cart = Cart();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(cart: _cart, maxQuantity: 5),
      routes: {
        '/order': (context) => OrderScreen(cart: _cart, maxQuantity: 5),
        '/cart': (context) => CartScreen(cart: _cart),
        '/about': (context) => const AboutScreen(),
        '/auth': (context) => const AuthScreen(),
      },
    );
  }
}