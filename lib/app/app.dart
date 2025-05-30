import 'package:flutter/material.dart';
import 'package:neura_app/app/core/router/app_router.dart';
import 'package:neura_app/app/core/theme/app_theme.dart';
import 'package:neura_app/app/shared/plugins/snackbar/providers/snackbar_provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final RouterManager _routerManager = RouterManager();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Actualizamos el router si es necesario
        _routerManager.updateRouter(context);

        return MaterialApp.router(
          title: 'Neura',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getTheme(),
          routeInformationParser: _routerManager.router.routeInformationParser,
          routerDelegate: _routerManager.router.routerDelegate,
          routeInformationProvider:
              _routerManager.router.routeInformationProvider,
          builder: (context, child) {
            return SnackbarProvider(
              child: child!,
            );
          },
        );
      },
    );
  }
}
