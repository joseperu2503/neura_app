import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neura_app/app/core/constants/app_colors.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: CustomScrollView(slivers: [])),
          Container(
            decoration: BoxDecoration(color: AppColors.dark1),
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.dark2,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(
                      color: AppColors.neutralOffWhite,
                      fontSize: 16,
                      height: 24 / 16,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.only(
                        left: 0,
                        right: 0,
                        top: 16,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primary2,
                            disabledBackgroundColor: AppColors.dark8,
                            padding: EdgeInsets.zero,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/send.svg',
                            width: 20,
                            colorFilter: const ColorFilter.mode(
                              AppColors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
