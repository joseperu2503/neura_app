import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neura_app/app/core/constants/breakpoints.dart';
import 'package:neura_app/app/core/theme/app_colors.dart';
import 'package:neura_app/app/shared/plugins/snackbar/enums/snackbar_type.dart';

class Snackbar extends StatelessWidget {
  const Snackbar({
    super.key,
    required this.message,
    required this.onClose,
    required this.type,
  });

  final String message;
  final void Function() onClose;
  final SnackbarType type;

  @override
  Widget build(BuildContext context) {
    late Color backgroundColor;
    late Color color;
    late String icon;

    if (type == SnackbarType.error) {
      backgroundColor = AppColors.backgroundError;
      color = AppColors.white;
      icon = 'assets/icons/error.svg';
    }

    if (type == SnackbarType.success) {
      backgroundColor = AppColors.backgroundSuccess;
      color = AppColors.white;
      icon = 'assets/icons/check.svg';
    }

    if (type == SnackbarType.info) {
      backgroundColor = AppColors.backgroundInfo;
      color = AppColors.white;
      icon = 'assets/icons/info.svg';
    }

    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
            minWidth: 320,
            maxWidth: MediaQuery.of(context).size.width - 32,
            minHeight: 44,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 20,
              ),
              SvgPicture.asset(
                icon,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                flex: Breakpoints.isMdUp(context) ? 0 : 1,
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: color,
                    height: 20 / 16,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onClose,
                  child: SvgPicture.asset(
                    'assets/icons/close.svg',
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      color,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
