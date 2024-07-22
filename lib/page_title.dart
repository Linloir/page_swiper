import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

typedef PageTitleBuilder = Widget Function({required double extent, Key? key});

class PageTitle extends StatelessWidget {
  static PageTitleBuilder builder({
    required String title,
    String? subtitle,
    List<Widget> actions = const <Widget>[]
  }) {
    return ({required double extent, Key? key}) => PageTitle(
      extent: extent,
      title: title,
      subtitle: subtitle,
      actions: actions,
      key: key,
    );
  }

  static const double titleFontSize = 42;
  static const double titleFontSizeCollapsed = 18;
  static const FontWeight titleFontWeight = FontWeight.w900;
  static const FontWeight titleFontWeightCollapsed = FontWeight.w600;
  static const int titleMaxLines = 1;
  static const double subtitleFontSize = 14;
  static const FontWeight subtitleFontWeight = FontWeight.normal;
  static const int subtitleMaxLines = 1;

  const PageTitle({
    required this.extent,
    required this.title,
    this.subtitle,
    this.actions = const <Widget>[],
    super.key,
  });

  /// Indicates the size of current title widget
  /// 0 indicates fully collapsed and value greater than 1 indicates an overshoot
  final double extent;
  final String title;
  final String? subtitle;
  final List<Widget> actions;

  double _getTitleFontSize() {
    return lerpDouble(titleFontSizeCollapsed, titleFontSize, extent)!; 
  }

  FontWeight _getTitleFontWeight() {
    return FontWeight.lerp(titleFontWeightCollapsed, titleFontWeight, extent)!;
  }

  double _getSubtitleContainerHeight() {
    if (subtitle == null) {
      return 0;
    }

    // Get the true height of the subtitle
    // TextStyle style = const TextStyle(fontSize: subtitleFontSize, fontWeight: subtitleFontWeight);
    // TextPainter painter = TextPainter(
    //   text: TextSpan(text: subtitle, style: style),
    //   textDirection: TextDirection.ltr
    // )..layout(minWidth: 0, maxWidth: double.infinity);

    // return lerpDouble(painter.size.height + 2, 0, extent)!.clamp(0, double.infinity);

    // Since line height is forced to be equal to font size, lerp start will be fontsize
    return lerpDouble(subtitleFontSize * 1.1, 0, extent)!.clamp(0, double.infinity);
  }

  double _getSubtitleContainerOpacity() {
    if (subtitle == null) {
      return 0;
    }

    return lerpDouble(1.0, 0.0, extent)!.clamp(0, 1);
  }

  double _getAlignmentY() {
    if (extent > 1) {
      return 1;
    }
    // return extent < 0.5 ? 2 * extent * extent : 1 - pow(-2 * extent + 2, 2) / 2;
    return 1.0 - pow(1.0 - extent, 3);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment(-1, _getAlignmentY()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: _getTitleFontSize(),
                  fontWeight: _getTitleFontWeight(),
                  overflow: TextOverflow.ellipsis,
                  color: Colors.black87,
                  height: 1.0,
                ),
                textAlign: TextAlign.start,
                maxLines: titleMaxLines,
              ),
              if (subtitle != null)
                SizedBox(
                  height: _getSubtitleContainerHeight(),
                  child: Opacity(
                    opacity: _getSubtitleContainerOpacity(),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: subtitleFontSize,
                        fontWeight: subtitleFontWeight,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black54,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: subtitleMaxLines,
                    ),
                  ),
                )
            ],
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment(1, _getAlignmentY()),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: actions,
          ),
        ),
      ],
    );
  }
}