import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/glass_button.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/photo_viewer_overlay.dart';

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

  static const String _heroTag = 'scan_result_image';

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
                GestureDetector(
                  onTap: () => PhotoViewerOverlay.show(
                    context,
                    imagePath: imagePath,
                    heroTag: _heroTag,
                  ),
                  child: Hero(
                    tag: _heroTag,
                    child: Image.file(File(imagePath), fit: BoxFit.cover),
                  ),
                ),

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
                          isDark
                              ? const Color(0xFF1A1A26)
                              : const Color(0xFFF2F3F8),
                        ],
                      ),
                    ),
                  ),
                ),

                if (!isCollapsed)
                  Positioned(
                    bottom: 56,
                    right: 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                              width: 0.5,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.zoom_out_map_rounded,
                                color: Colors.white,
                                size: 13,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Tap to expand',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

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
                          GlassButton(icon: Icons.share_rounded, onTap: () {}),
                        ],
                      ),
                    ),
                  ),
                ),

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
