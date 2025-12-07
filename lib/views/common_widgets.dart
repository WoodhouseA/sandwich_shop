import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      textStyle: AppStyles.normalText,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: myButtonStyle,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shopping_cart),
              const SizedBox(width: 4),
              Text('${cart.countOfItems}'),
            ],
          ),
        );
      },
    );
  }
}

class SandwichShopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showCartAction;

  const SandwichShopAppBar({
    super.key,
    required this.title,
    this.showCartAction = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
      title: Text(
        title,
        style: AppStyles.heading1,
      ),
      actions: showCartAction ? [const CartBadge()] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

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
          _buildListTile(context, 'Profile', Icons.person, '/profile'),
          const Divider(),
          _buildListTile(context, 'Settings', Icons.settings, '/settings'),
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

class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final Widget? title;
  final String currentRoute;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    required this.currentRoute,
    this.title,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile: Modal Drawer
          return Scaffold(
            appBar: AppBar(
              title: title,
              actions: actions,
            ),
            drawer: AppDrawer(currentRoute: currentRoute),
            body: body,
            floatingActionButton: floatingActionButton,
          );
        } else {
          // Desktop: Permanent Sidebar
          return Scaffold(
            appBar: AppBar(
              title: title,
              actions: actions,
              // On desktop, we might want to hide the hamburger if we have a sidebar
              automaticallyImplyLeading: false,
            ),
            body: Row(
              children: [
                SizedBox(
                  width: 250,
                  child: AppDrawer(currentRoute: currentRoute),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ],
            ),
            floatingActionButton: floatingActionButton,
          );
        }
      },
    );
  }
}
