import 'package:flutter/material.dart';

class PageTitlePlaceholder extends StatelessWidget {
  const PageTitlePlaceholder({
    required this.height,
    super.key
  });

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