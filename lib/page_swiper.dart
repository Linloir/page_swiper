/// A skeleton to build UI with different pages and title on them
library page_swiper;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:page_swiper/page_container.dart';
import 'package:page_swiper/page_title.dart';
import 'package:page_swiper/page_title_container.dart';
import 'package:page_swiper/page_title_filter.dart';

class PageSwiper extends StatefulWidget {
  static const double defaultMaxExtend = 1.2;

  const PageSwiper({
    super.key,
    required this.pageNum,
    required this.pageController,
    required this.titleHeight,
    required this.titleHeightCollapsed,
    this.titleFilterBackground,
    this.titleFilterSigma,
    this.titleMaxExtend,
    required this.titles,
    required this.pages,
    required this.pageScrollControllers,
    this.blurByPage,
  }): assert(pageNum > 0),
    assert(pageNum == titles.length),
    assert(pageNum == pages.length),
    assert(pageNum == pageScrollControllers.length),
    assert(titleHeight >= 0),
    assert(titleHeightCollapsed >= 0);

  /// Total page num
  final int pageNum;
  /// Passing page controller inside allows the parent widget to gain
  /// control of the page switching and listen to the changes
  final PageController pageController;
  final double titleHeight;
  final double titleHeightCollapsed;
  final Color? titleFilterBackground;
  final double? titleFilterSigma;
  final double? titleMaxExtend;
  final List<PageTitleBuilder> titles;
  final List<PageContainerBuilder> pages;
  final List<ScrollController> pageScrollControllers;
  final bool? blurByPage;

  @override
  State<PageSwiper> createState() => _PageSwiperState();
}

class _PageSwiperState extends State<PageSwiper> {
  /// The calculated height of the title widget
  late double _titleBarHeight;

  @override
  void initState() {
    // Initialize title bar height
    _titleBarHeight = widget.titleHeight;

    widget.pageController.addListener(_updateTitleBarHeight);
    for (ScrollController controller in widget.pageScrollControllers) {
      controller.addListener(_updateTitleBarHeight);
    }

    super.initState();
  }

  void _updateTitleBarHeight() {
    if (widget.pageController.page == null) {
      return;
    }

    int leftParticipantPage = widget.pageController.page!.floor();
    int rightParticipantPage = widget.pageController.page!.ceil();
    double offset = widget.pageController.page! - leftParticipantPage;

    ScrollController leftParticipantPageController = widget.pageScrollControllers[leftParticipantPage];
    ScrollController rightParticipantPageController = widget.pageScrollControllers[rightParticipantPage];

    double leftPageOffset = 0.0;
    if (leftParticipantPageController.hasClients) {
      leftPageOffset = leftParticipantPageController.offset;
    }
    double rightPageOffset = 0.0;
    if (rightParticipantPageController.hasClients) {
      rightPageOffset = rightParticipantPageController.offset;
    }

    double leftPageHeight = max(widget.titleHeight - leftPageOffset, widget.titleHeightCollapsed);
    double rightPageHeight = max(widget.titleHeight - rightPageOffset, widget.titleHeightCollapsed);

    double currentHeight = leftPageHeight + offset * (rightPageHeight - leftPageHeight);

    setState(() {
      _titleBarHeight = currentHeight;
    });
  }

  double _getTitleExtend() {
    double range = widget.titleHeight - widget.titleHeightCollapsed;
    double cur = _titleBarHeight - widget.titleHeightCollapsed;
    return (cur / range).clamp(0, widget.titleMaxExtend ?? PageSwiper.defaultMaxExtend);
  }

  @override
  Widget build(BuildContext context) {
    double titleExtend = _getTitleExtend();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView(
              controller: widget.pageController,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              children: [
                for (PageContainerBuilder builder in widget.pages)
                  builder(
                    titleFilterHeight: _titleBarHeight,
                    titleExtend: titleExtend,
                    filterBackground: widget.titleFilterBackground,
                    filterSigma: widget.titleFilterSigma,
                    blurByPage: widget.blurByPage,
                  )
              ],
            ),
          ),
          if (!(widget.blurByPage ?? false))
            Positioned(
              top: 0, left: 0, right: 0, height: _titleBarHeight,
              child: Opacity(
                opacity: (pow(1 - titleExtend, 4).toDouble()).clamp(0, 1),
                child: PageTitleFilter(
                  background: Colors.white.withAlpha(150),
                  // sigma: widget.filterSigma,
                ),
              ),
            ),
          for (int i = 0; i < widget.pageNum; i++)
            PageTitleContainer(
              height: _titleBarHeight,
              titlePageIndex: i,
              currentPageIndex: widget.pageController.hasClients ? 
                widget.pageController.page ?? widget.pageController.initialPage.toDouble() :
                widget.pageController.initialPage.toDouble(),
              child: widget.titles[i](extent: titleExtend),
            ),
        ]
      )
    );
  }
}
