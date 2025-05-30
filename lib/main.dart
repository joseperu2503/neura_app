import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neura_app/app/app.dart';
import 'package:neura_app/app/core/constants/environment.dart';
import 'package:neura_app/app/core/theme/app_colors.dart';
import 'package:neura_app/di.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.dark2,
    ),
  );

  await Environment.initEnvironment();
  setup(); // Inicializar inyección de dependencias
  runApp(const App());
}
