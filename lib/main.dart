import 'package:flutter/material.dart';
import 'package:neura_app/app/app.dart';
import 'package:neura_app/app/core/constants/environment.dart';
import 'package:neura_app/app/di.dart';

void main() async {
  await Environment.initEnvironment();
  setup(); // Inicializar inyección de dependencias
  runApp(const App());
}
