import 'package:flutter/material.dart';

class PageTitleContainer extends StatelessWidget {
  const PageTitleContainer({
    required this.height,
    required this.titlePageIndex,
    required this.currentPageIndex,
    required this.child,
    super.key,
  });

  static const double maxTranslation = 50;

  final double height;
  final int titlePageIndex;
  final double currentPageIndex;
  final Widget child;

  /// Calculate the current translation based on the title index and page index
  double _getTranslateX() {
    return maxTranslation * _getOffset();
  }

  /// Calculate the current opacity based on the title index and page index
  double _getOpacity() {
    return 1 - _getOffset().abs();
  }

  /// Get the current offset, indicates the relative position of the current
  /// title to that of a title designed to be
  /// 
  /// For example, if the title index is 1, say, it's on the second page,
  /// if the current page index is 1.3, then the offset should be -0.3. If
  /// the current page index is 0.9, then the offset should be +0.1.
  /// 
  /// The offset is clamped to [-1, 1]
  double _getOffset() {
    return (titlePageIndex - currentPageIndex).clamp(-1, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0, left: 0, right: 0, height: height,
      child: Transform.translate(
        offset: Offset(_getTranslateX(), 0),
        child: Opacity(
          opacity: _getOpacity(),
          child: SafeArea(
            top: true, left: false, right: false, bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}