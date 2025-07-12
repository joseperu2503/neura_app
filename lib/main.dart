import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neura_app/app/app.dart';
import 'package:neura_app/app/core/environments/environments.dart';
import 'package:neura_app/app/core/theme/app_colors.dart';
import 'package:neura_app/service_locator.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.dark2,
    ),
  );

  await Environments.init();
  setup(); // Inicializar inyección de dependencias
  runApp(const App());
}
