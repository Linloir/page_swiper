import 'package:flutter/material.dart';
import 'package:page_swiper/page_swiper.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({
    required this.controller,
    required this.titleHeight,
    super.key
  });

  final ScrollController controller;
  final double titleHeight;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Positioned.fill(
          child: CustomScrollView(
            controller: widget.controller,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              PageTitlePlaceholder(height: widget.titleHeight),
              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  color: Colors.red,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  color: Colors.green,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  color: Colors.red,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  color: Colors.green,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  color: Colors.red,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}