import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/core/router/app_router.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/bounding_box_overlay.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/glass_button.dart';
import 'package:powerocr/features/scanning/presentation/screens/scan_result_screen/widgets/photo_viewer_overlay.dart';
import 'package:powerocr/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams, XFile;

class ResultSliverAppBar extends StatelessWidget {
  final String imagePath;
  final double expandedHeight;
  final bool isDark;
  final List<List<double>>? boundingBoxes;
  final int imageWidth;
  final int imageHeight;
  final ScanHistoryType? scanType;

  const ResultSliverAppBar({
    super.key,
    required this.imagePath,
    required this.expandedHeight,
    required this.isDark,
    this.boundingBoxes,
    this.imageWidth = 0,
    this.imageHeight = 0,
    this.scanType,
  });

  static const String _heroTag = 'scan_result_image';

  bool get _isDocumentWithBoundingBoxes =>
      scanType == ScanHistoryType.document &&
      boundingBoxes != null &&
      boundingBoxes!.isNotEmpty;

  Future<void> onShare(BuildContext context) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(imagePath)],
          text: AppLocalizations.of(context)!.shareImage,
        ),
      );
    } catch (e) {}
  }

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
                _isDocumentWithBoundingBoxes
                    ? BoundingBoxOverlay(
                        imagePath: imagePath,
                        boundingBoxes: boundingBoxes ?? [],
                        imageWidth: imageWidth,
                        imageHeight: imageHeight,
                        onImageTap: () => PhotoViewerOverlay.show(
                          context,
                          imagePath: imagePath,
                          boundingBoxes: boundingBoxes ?? [],
                          imageWidth: imageWidth,
                          imageHeight: imageHeight,
                          heroTag: _heroTag,
                        ),
                      )
                    : GestureDetector(
                        onTap: () => PhotoViewerOverlay.show(
                          context,
                          imagePath: imagePath,
                          boundingBoxes: boundingBoxes ?? [],
                          imageWidth: imageWidth,
                          imageHeight: imageHeight,
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
                  child: IgnorePointer(
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.zoom_out_map_rounded,
                                color: Colors.white,
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.scanResultTapToZoom,
                                style: const TextStyle(
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
                            onTap: () => context.go(AppRouter.main),
                          ),
                          GlassButton(
                            icon: Icons.share_rounded,
                            onTap: () => onShare(context),
                          ),
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
