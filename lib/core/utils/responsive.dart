import 'package:flutter/material.dart';

/// Breakpoint-based responsive utilities for PowerOCR.
///
/// Tablet is defined as [shortestSide] >= 600 dp — covers iPad and large
/// Android tablets in both portrait and landscape orientation.
class AppBreakpoints {
  AppBreakpoints._();

  static const double _tabletShortestSide = 600;
  static const double maxContentWidth = 760;

  /// Returns `true` when the device is a tablet (≥ 600 dp shortest side).
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= _tabletShortestSide;

  /// Horizontal padding: 40 dp on tablet, 20 dp on phone.
  static double horizontalPadding(BuildContext context) =>
      isTablet(context) ? 40 : 20;
}

/// Wraps [child] in a centered, max-width constrained box on tablet.
/// On mobile the child is returned with no structural wrapping.
class ResponsiveContentBox extends StatelessWidget {
  const ResponsiveContentBox({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.maxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    if (!AppBreakpoints.isTablet(context)) return child;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
