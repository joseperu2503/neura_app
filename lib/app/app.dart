import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key, required this.child});

  final Widget? child;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    if (widget.child == null) return Container();

    return widget.child!;
  }
}
