import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neura_app/app/core/theme/app_colors.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({super.key});

  Widget _menuItem(String text, String icon) {
    return ListTile(
      onTap: () {
        print("Seleccionaste: $icon");
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      leading: SvgPicture.asset(
        'assets/icons/$icon.svg',
        width: 24,
        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
      ),
      title: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: AppColors.dark3,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          const BoxShadow(
            color: AppColors.dark1,
            blurRadius: 8,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _menuItem("Good Response", "like"),
              _menuItem("Bad Response", "dislike"),
            ],
          ),
        ),
      ),
    );
  }
}
