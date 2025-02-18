import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neura_app/app/app.dart';
import 'package:neura_app/app/core/constants/breakpoints.dart';
import 'package:neura_app/app/core/router/app_router.dart';
import 'package:get/get.dart';
import 'package:neura_app/app/core/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  RouterType _previousRouterType = RouterType.mobile;
  GoRouter router = appRouter('/', RouterType.mobile);

  RouterType get _currentRouterType {
    return Breakpoints.isMdDown(context)
        ? RouterType.mobile
        : RouterType.desktop;
  }

  void _updateRouter() {
    final currentRouterType = _currentRouterType;

    if (currentRouterType != _previousRouterType) {
      _previousRouterType = currentRouterType;

      final currentRoute =
          router.routerDelegate.currentConfiguration.uri.toString();

      setState(() {
        router = appRouter(currentRoute, currentRouterType);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build');

    return LayoutBuilder(
      builder: (context, constraints) {
        // Actualizamos el router si es necesario
        _updateRouter();
        print('LayoutBuilder');

        return GetMaterialApp.router(
          title: 'Neura',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getTheme(),
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
          builder: (context, child) => App(child: child),
        );
      },
    );
  }
}
