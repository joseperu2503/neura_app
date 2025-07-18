import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neura_app/app/core/theme/app_colors.dart';

class AnimatedMenu extends StatefulWidget {
  final double dx;
  final double? top;
  final double? bottom;
  final bool alignLeft;
  final double screenWidth;
  final double menuWidth;
  final String verticalAlign;
  final VoidCallback onDismiss;

  const AnimatedMenu({
    super.key,
    required this.dx,
    required this.top,
    required this.bottom,
    required this.alignLeft,
    required this.screenWidth,
    required this.menuWidth,
    required this.verticalAlign,
    required this.onDismiss,
  });

  @override
  State<AnimatedMenu> createState() => _AnimatedMenuState();
}

class _AnimatedMenuState extends State<AnimatedMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;
  late Animation<double> _scaleAnim;

  late Alignment alignment;

  @override
  void initState() {
    super.initState();

    alignment = _getAlignment();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 150), // Puedes subirlo si quieres
      vsync: this,
    );

    _opacityAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scaleAnim = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  Alignment _getAlignment() {
    // Determinar el origen de la animación según verticalAlign y alignLeft
    if (widget.verticalAlign == "top") {
      return widget.alignLeft ? Alignment.topLeft : Alignment.topRight;
    } else if (widget.verticalAlign == "bottom") {
      return widget.alignLeft ? Alignment.bottomLeft : Alignment.bottomRight;
    } else {
      return widget.alignLeft ? Alignment.centerLeft : Alignment.centerRight;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: widget.top,
              bottom: widget.bottom,
              left: widget.alignLeft ? widget.dx : null,
              right: widget.alignLeft ? null : (widget.screenWidth - widget.dx),
              child: TapRegion(
                onTapOutside: (event) {
                  widget.onDismiss();
                },
                child: Opacity(
                  opacity: _opacityAnim.value,
                  child: Transform.scale(
                    scale: _scaleAnim.value,
                    alignment: alignment,
                    child: Container(
                      width: widget.menuWidth,
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
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
}
