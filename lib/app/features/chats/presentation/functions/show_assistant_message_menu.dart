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
  const menuWidth = 200.0;
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
      // return Stack(
      //   children: [
      //     Positioned(
      //       top: top,
      //       bottom: bottom,
      //       left: alignLeft ? dx : null,
      //       right: alignLeft ? null : (screenWidth - dx),
      //       child: TapRegion(
      //         onTapOutside: (event) {
      //           menuOverlay?.remove();
      //         },
      //         child: Opacity(
      //           opacity: _opacityAnim.value,
      //           child: Transform.scale(
      //             scale: _scaleAnim.value,
      //             alignment: alignment,
      //             child: Container(
      //               width: widget.menuWidth,
      //               decoration: BoxDecoration(
      //                 color: AppColors.dark3,
      //                 borderRadius: BorderRadius.circular(12),
      //                 boxShadow: [
      //                   const BoxShadow(
      //                     color: AppColors.dark1,
      //                     blurRadius: 8,
      //                     offset: Offset(2, 2),
      //                   ),
      //                 ],
      //               ),
      //               child: ClipRRect(
      //                 borderRadius: BorderRadius.circular(12),
      //                 child: Material(
      //                   color: Colors.transparent,
      //                   child: Column(
      //                     mainAxisSize: MainAxisSize.min,
      //                     children: [
      //                       _menuItem("Good Response", "like"),
      //                       _menuItem("Bad Response", "dislike"),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // );
      return AnimatedMenu(
        dx: dx,
        top: top,
        bottom: bottom,
        alignLeft: alignLeft,
        screenWidth: screenSize.width,
        menuWidth: menuWidth,
        verticalAlign: verticalAlign,
        onDismiss: () {
          menuOverlay?.remove();
        },
      );
    },
  );

  Overlay.of(context).insert(menuOverlay);
}
