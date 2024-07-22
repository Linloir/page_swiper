import 'dart:ui';

import 'package:flutter/material.dart';

/// The blur filter for title bar widget
class PageTitleFilter extends StatelessWidget {
  /// The default blur sigma value
  static const double defaultSigma = 50;

  /// The default title bar background color when it's collapsed
  static const Color defaultBackground = Colors.transparent;

  /// Default constructor for [PageTitleFilter]
  const PageTitleFilter({
    this.background,
    this.sigma,
    super.key,
  });

  /// The title bar background color when it's collapsed
  final Color? background;

  /// The blur sigma value
  final double? sigma;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: sigma ?? defaultSigma,
              sigmaY: sigma ?? defaultSigma,
              tileMode: TileMode.clamp),
          child: Container(
            color: background ?? defaultBackground,
          )),
    );
  }
}
