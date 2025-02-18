import 'package:flutter/material.dart';
import 'package:neura_app/app/features/chats/presentation/screens/chat_screen.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

enum RouterType { mobile, desktop }

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
