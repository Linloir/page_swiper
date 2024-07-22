import 'dart:math';

import 'package:flutter/material.dart';
import 'package:page_swiper/src/page_title_filter.dart';

/// Builder function to build up a [PageContainer] inside [PageSwiper]
typedef PageContainerBuilder = Widget Function({
  required double titleFilterHeight,
  required double titleExtend,
  Color? filterBackground,
  double? filterSigma,
  bool? blurByPage,
});

/// Container widget for user-written pages
///
/// Use the [PageContainer.childBuilder] to generate a builder that builds
/// your [child] page with corresponding context inside [PageSwiper]
class PageContainer extends StatelessWidget {
  static PageContainerBuilder childBuilder({required Widget child}) {
    return ({
      required double titleFilterHeight,
      required double titleExtend,
      Color? filterBackground,
      double? filterSigma,
      bool? blurByPage,
    }) {
      return PageContainer(
        titleFilterHeight: titleFilterHeight,
        titleExtend: titleExtend,
        filterBackground: filterBackground,
        filterSigma: filterSigma,
        blurByPage: blurByPage,
        child: child,
      );
    };
  }

  /// Default constructor, you shall not use this constructor,
  /// use the [PageContainer.childBuilder] instead
  const PageContainer({
    required this.titleFilterHeight,
    required this.titleExtend,
    this.filterBackground,
    this.filterSigma,
    this.blurByPage,
    required this.child,
    super.key,
  });

  /// The current title bar height,
  /// not the preset height of normal/collapsed state
  final double titleFilterHeight;

  /// The current extend amount of the title bar,
  /// range from 0 to max extend (may be larger than 1)
  final double titleExtend;

  /// The background color of the title bar when it's collapsed,
  /// defaults to Colors.transparent
  final Color? filterBackground;

  /// The sigma of blur of the title bar when it's collapsed,
  /// defaults to 50
  final double? filterSigma;

  /// Whether to show the title bar by page,
  /// defaults to false
  final bool? blurByPage;

  /// Your page widget, should be a [CustomScrollView]
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: child,
      ),
      if (blurByPage ?? false)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: titleFilterHeight,
          child: Opacity(
            opacity: (pow(1 - titleExtend, 4).toDouble()).clamp(0, 1),
            child: PageTitleFilter(
              background: filterBackground,
              sigma: filterSigma,
            ),
          ),
        ),
    ]);
  }
}
