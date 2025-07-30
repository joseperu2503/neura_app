import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neura_app/app/core/router/app_router.dart';
import 'package:neura_app/app/core/theme/app_theme.dart';
import 'package:neura_app/app/features/auth/domain/usecases/guest_register.dart';
import 'package:neura_app/app/features/auth/domain/usecases/is_loggued_in.dart';
import 'package:neura_app/app/features/auth/domain/usecases/logout.dart';
import 'package:neura_app/app/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:neura_app/app/features/chats/presentation/blocs/chat/chat_cubit.dart';
import 'package:neura_app/app/shared/plugins/snackbar/providers/snackbar_provider.dart';
import 'package:neura_app/service_locator.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final RouterManager _routerManager = RouterManager();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create:
              (context) => AuthBloc(
                sl<GuestRegisterUseCase>(),
                sl<IsLogguedInUseCase>(),
                sl<LogoutUseCase>(),
              ),
        ),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Actualizamos el router si es necesario
          _routerManager.updateRouter(context);

          return MaterialApp.router(
            title: 'Neura',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(),
            routeInformationParser:
                _routerManager.router.routeInformationParser,
            routerDelegate: _routerManager.router.routerDelegate,
            routeInformationProvider:
                _routerManager.router.routeInformationProvider,
            builder: (context, child) {
              return SnackbarProvider(child: child!);
            },
          );
        },
      ),
    );
  }
}
