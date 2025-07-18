import 'package:flutter/material.dart';
import 'package:neura_app/app/features/chats/presentation/widgets/animated_menu.dart';

void showAssistanMessageMenu({
  required BuildContext context,
  required Offset position,
  required void Function() goodResponse,
  required void Function() badResponse,
}) {
  OverlayEntry? menuOverlay;

  final screenSize = MediaQuery.of(context).size;
  const menuHeight = 100.0;
  const safeBottom = 200.0;

  double dx = position.dx;
  double dy = position.dy;

  bool alignLeft = dx < screenSize.width / 2;

  // Determinar comportamiento vertical
  String verticalAlign; // "top", "bottom", "center"
  if (dy < screenSize.height / 3) {
    verticalAlign = "top"; // hacia abajo
  } else if (dy > screenSize.height * 2 / 3) {
    verticalAlign = "bottom"; // hacia arriba
  } else {
    verticalAlign = "center"; // centrado
  }

  // Ajustar posición vertical
  double? top;
  double? bottom;

  if (verticalAlign == "top") {
    top = dy;
    if (top + menuHeight > screenSize.height - safeBottom) {
      top = screenSize.height - safeBottom - menuHeight - 8;
    }
  } else if (verticalAlign == "bottom") {
    bottom = screenSize.height - dy;
    if (bottom + menuHeight > screenSize.height - safeBottom) {
      bottom = screenSize.height - safeBottom - menuHeight - 8;
    }
  } else {
    // Prioridad: mostrar hacia abajo si hay espacio
    double spaceBelow = screenSize.height - safeBottom - dy - menuHeight;

    if (spaceBelow >= 0) {
      // Hay espacio hacia abajo → mostrar debajo del toque
      top = dy;
    } else {
      // No hay espacio suficiente → mostrar hacia arriba
      top = screenSize.height - safeBottom - menuHeight - 8;
    }
  }

  menuOverlay = OverlayEntry(
    builder: (context) {
      return _CustomOverlay(
        dx: dx,
        top: top,
        bottom: bottom,
        alignLeft: alignLeft,
        screenWidth: screenSize.width,
        verticalAlign: verticalAlign,
        onDismiss: () {
          menuOverlay?.remove();
        },
        child: const CustomMenu(),
      );
    },
  );

  Overlay.of(context).insert(menuOverlay);
}

class _CustomOverlay extends StatefulWidget {
  final double dx;
  final double? top;
  final double? bottom;
  final bool alignLeft;
  final double screenWidth;
  final String verticalAlign;
  final VoidCallback onDismiss;
  final Widget child;

  const _CustomOverlay({
    required this.dx,
    required this.top,
    required this.bottom,
    required this.alignLeft,
    required this.screenWidth,
    required this.verticalAlign,
    required this.onDismiss,
    required this.child,
  });

  @override
  State<_CustomOverlay> createState() => _CustomOverlayState();
}

class _CustomOverlayState extends State<_CustomOverlay>
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
      duration: const Duration(milliseconds: 150),
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
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
