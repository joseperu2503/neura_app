import 'package:flutter/material.dart';
import 'package:neura_app/app/core/constants/app_colors.dart';

class AssistantTyping extends StatefulWidget {
  const AssistantTyping({super.key});

  @override
  AssistantTypingState createState() => AssistantTypingState();
}

class AssistantTypingState extends State<AssistantTyping> {
  List<double> scales = [1.0, 1.0, 1.0];

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    for (int i = 0; i < scales.length; i++) {
      Future.delayed(Duration(milliseconds: i * 333), () {
        if (mounted) {
          _animateDot(i);
        }
      });
    }
  }

  void _animateDot(int index) {
    Future.doWhile(() async {
      if (!mounted) return false;
      setState(() {
        scales[index] = 1.4;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return false;
      setState(() {
        scales[index] = 1.0;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.dark5,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6,
        children: List.generate(3, (index) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              const SizedBox(width: 10, height: 10),
              AnimatedPositioned(
                top: (10 - 10 * scales[index]) / 2,
                right: (8 - 10 * scales[index]),
                duration: const Duration(milliseconds: 500),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width:
                      10 * scales[index], // Cambio de tamaño en lugar de escala
                  height: 10 * scales[index],
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
