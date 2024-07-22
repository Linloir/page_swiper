import 'dart:math';

import 'package:flutter/material.dart';
import 'package:page_swiper/src/page_title_filter.dart';

typedef PageContainerBuilder = Widget Function({
  required double titleFilterHeight,
  required double titleExtend,
  Color? filterBackground,
  double? filterSigma,
  bool? blurByPage,
});

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

  const PageContainer({
    required this.titleFilterHeight,
    required this.titleExtend,
    this.filterBackground,
    this.filterSigma,
    this.blurByPage,
    required this.child,
    super.key,
  });

  final double titleFilterHeight;
  final double titleExtend;
  final Color? filterBackground;
  final double? filterSigma;
  final bool? blurByPage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: child,
        ),
        if (blurByPage ?? false)
          Positioned(
            top: 0, left: 0, right: 0, height: titleFilterHeight,
            child: Opacity(
              opacity: (pow(1 - titleExtend, 4).toDouble()).clamp(0, 1),
              child: PageTitleFilter(
                background: filterBackground,
                sigma: filterSigma,
              ),
            ),
          ),
      ]
    );
  }
}