import 'dart:ui';

import 'package:flutter/material.dart';

class PageTitleFilter extends StatelessWidget {
  static const double defaultSigma = 50;
  static const Color defaultBackground = Colors.transparent;

  const PageTitleFilter({
    this.background,
    this.sigma,
    super.key,
  });

  final Color? background;
  final double? sigma;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: sigma ?? defaultSigma,
          sigmaY: sigma ?? defaultSigma,
          tileMode: TileMode.clamp
        ),
        child: Container(
          color: background ?? defaultBackground,
        )
      ),
    );
  }
}