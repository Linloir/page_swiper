import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

/// Builder function for generating page title widgets in a certain context
typedef PageTitleBuilder = Widget Function({required double extent, Key? key});

/// Real widget that displays the page title
class PageTitle extends StatelessWidget {
  /// Creates a builder that use your title settings to generate a title widget
  /// under the specific context of the [PageSwiper]
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

  /// The normal-state title font size
  static const double titleFontSize = 42;
  /// The collapsed-state title font size
  static const double titleFontSizeCollapsed = 18;
  /// The normal-state title font weight
  static const FontWeight titleFontWeight = FontWeight.w900;
  /// The collapsed-state title font weight
  static const FontWeight titleFontWeightCollapsed = FontWeight.w600;
  /// The max line of title text
  static const int titleMaxLines = 1;
  /// The subtitle font size
  static const double subtitleFontSize = 14;
  /// The subtitle font weight
  static const FontWeight subtitleFontWeight = FontWeight.normal;
  /// The max line of subtitle text
  static const int subtitleMaxLines = 1;

  /// Default constructor, you shall not be using this to construct your title widget,
  /// instead use the [PageTitle.builder] method
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
  /// Your title text
  final String title;
  /// Your subtitle text
  final String? subtitle;
  /// Action widgets, such as [TextButton]
  final List<Widget> actions;

  /// Get the current title font based on the title extent
  double _getTitleFontSize() {
    return lerpDouble(titleFontSizeCollapsed, titleFontSize, extent)!; 
  }

  /// Get the current title weight based on the title extent
  FontWeight _getTitleFontWeight() {
    return FontWeight.lerp(titleFontWeightCollapsed, titleFontWeight, extent)!;
  }

  /// Get the current subtitle wrapper container height based on the title extent
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

  /// Get the current subtitle opacity based on the title extent
  double _getSubtitleContainerOpacity() {
    if (subtitle == null) {
      return 0;
    }

    return lerpDouble(1.0, 0.0, extent)!.clamp(0, 1);
  }

  /// Get the current Y axis alignment value based on the title extent
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