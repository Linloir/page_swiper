import 'package:flutter/material.dart';

/// A placeholder widget for leaving space in your page for title bar,
/// you should use it in [CustomScrollView.slivers]
class PageTitlePlaceholder extends StatelessWidget {
  /// Default constructor
  const PageTitlePlaceholder({
    required this.height,
    super.key
  });

  /// The normal-state height of the title bar
  final double height;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: height,
      ),
    );
  }
}