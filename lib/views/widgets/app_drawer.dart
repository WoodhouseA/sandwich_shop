import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.fastfood, size: 48, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Sandwich Shop',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildListTile(context, 'Order', Icons.restaurant_menu, '/order'),
          _buildListTile(context, 'Cart', Icons.shopping_cart, '/cart'),
          _buildListTile(context, 'About', Icons.info, '/about'),
          const Divider(),
          _buildListTile(context, 'Sign In / Sign Up', Icons.person, '/auth'),
        ],
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, String title, IconData icon, String route) {
    final bool isSelected = currentRoute == route;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : null),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      onTap: () {
        if (isSelected) {
          if (Scaffold.of(context).hasDrawer &&
              Scaffold.of(context).isDrawerOpen) {
            Navigator.pop(context);
          }
          return;
        }

        // Close drawer if open
        if (Scaffold.of(context).hasDrawer &&
            Scaffold.of(context).isDrawerOpen) {
          Navigator.pop(context);
        }

        // Navigate
        if (route == '/order') {
          // Go back to home
          Navigator.pushNamedAndRemoveUntil(
              context, '/order', (route) => false);
        } else {
          // Push new screen
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
