import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/glass_button.dart';

class ResultSliverAppBar extends StatelessWidget {
  final String imagePath;
  final double expandedHeight;
  final bool isDark;

  const ResultSliverAppBar({
    super.key,
    required this.imagePath,
    required this.expandedHeight,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: expandedHeight,
      backgroundColor: Colors.black,
      leading: const SizedBox(),
      flexibleSpace: LayoutBuilder(
        builder: (ctx, constraints) {
          final isCollapsed = constraints.maxHeight <= kToolbarHeight + 4;
          return FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),
                // Bottom fade into sheet color
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          isDark ? const Color(0xFF1A1A26) : const Color(0xFFF2F3F8),
                        ],
                      ),
                    ),
                  ),
                ),
                // Overlay buttons row
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GlassButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            onTap: () => context.go(AppRouter.home),
                          ),
                          GlassButton(
                            icon: Icons.share_rounded,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Collapsed appbar backdrop (when scrolled up)
                if (isCollapsed)
                  Positioned.fill(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
