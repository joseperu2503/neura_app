import 'package:flutter/material.dart';
import 'package:neura_app/app/core/constants/breakpoints.dart';
import 'package:neura_app/app/features/chats/presentation/screens/chat_screen.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

enum RouterType { mobile, desktop }

class RouterManager {
  RouterType _previousRouterType = RouterType.mobile;
  late GoRouter router;

  RouterManager() {
    router = _createAppRouter('/', RouterType.mobile);
  }

  RouterType _getCurrentRouterType(BuildContext context) {
    return Breakpoints.isMdDown(context)
        ? RouterType.mobile
        : RouterType.desktop;
  }

  GoRouter _createAppRouter(String initialRoute, RouterType routerType) {
    return appRouter(initialRoute, routerType);
  }

  void updateRouter(BuildContext context) {
    final currentRouterType = _getCurrentRouterType(context);

    if (currentRouterType != _previousRouterType) {
      _previousRouterType = currentRouterType;

      final currentRoute =
          router.routerDelegate.currentConfiguration.uri.toString();
      router = _createAppRouter(currentRoute, currentRouterType);
    }
  }

  appRouter(String initialLocation, RouterType routerType) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ChatScreen(),
          parentNavigatorKey: rootNavigatorKey,
        ),
      ],
    );
  }
}
