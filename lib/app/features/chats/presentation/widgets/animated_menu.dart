import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neura_app/app/core/theme/app_colors.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({super.key, required this.options});
  final List<MenuOption> options;

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
              for (final option in options)
                ListTile(
                  onTap: () {
                    option.onTap();
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  leading: SvgPicture.asset(
                    'assets/icons/${option.icon}.svg',
                    width: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  title: Text(
                    option.text,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuOption {
  const MenuOption({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final String icon;
  final VoidCallback onTap;
}
