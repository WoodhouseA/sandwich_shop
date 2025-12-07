import 'package:flutter/material.dart';
import 'app_drawer.dart';

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
