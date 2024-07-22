<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

An easy-to-use scaffold for building UI with multiple scrollable pages, providing simple APIs, sufficient customization as well as good aesthetics that helps you focus on the page logic much faster.

## Features

> Having different function pages is a common requirement in app developments, thus making it inevitable to build the outer wrapper controller widget that holds, controls and delivers the pages.
>
> In most cases it's quite enough for just compositing the `PageView` or `TabView` with your page widgets, however in some special UI designs, where a persistent title bar or transition animation comes together with scrolling pages, it becomes a disaster.
>
> Therefore, I developed this small package for dealing with such design.

The package provides a `PageSwiper` widget by which you can create a horizontal-scrollable `PageView`, in which you can place your pages which are built on top of the `CustomScrollView` widget. It also provides you with a title bar that you can place your title, subtitle, and action buttons for each page, the package will handle the design and transition animations for you.

TL,DR;
This is a package that provides API for implementing UI designs as below:

![example gif](https://raw.githubusercontent.com/Linloir/page_swiper/main/demo/example.gif)

## Getting started

To use the package, just add it to your `pubspec.yaml` file:

```shell
flutter pub add page_swiper
```

## Usage

First, you need to create a page controller and several scroll controllers, one for each page, for the `PageSwiper` to use later. Just make your root page widget stateful and add some initialization there:

```dart
class MainPage extends StatefulWidget {
    static const pageNum = 2;

    const MainPage({
        this.initialPage = 1,
        this.titleHeight = 250,
        this.titleHeightCollapsed = 100,
        super.key
    });

    final int initialPage;
    final double titleHeight;
    final double titleHeightCollapsed;

    @override
    State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
    late PageController _pageController;
    late List<ScrollController> _pageScrollControllers;

    @override
    void initState() {
        _pageController = PageController(initialPage: widget.initialPage);
        _pageScrollControllers = [
        for (int i = 0; i < MainPage.pageNum; i++)
            ScrollController()
        ];
        super.initState();
    }

    @override
    void dispose() {
        _pageController.dispose();
        for (int i = 0; i < MainPage.pageNum; i++) {
            _pageScrollControllers[i].dispose();
        }
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        // ...
    }
}
```

Next, include the `PageSwiper` widget in your widget tree. `PageSwiper` works better with a `Scaffold` on the outside, so just wrap it up.

```dart
@override
Widget build(BuildContext context) {
    return Scaffold(
        body: PageSwiper(
            pageNum: 2,
            pageController: _pageController,
            titleHeight: widget.titleHeight,
            titleHeightCollapsed: widget.titleHeightCollapsed,
            titleFilterBackground: Colors.white.withAlpha(150),
            titleFilterSigma: 50,
            blurByPage: false,
            titleMaxExtend: 1.3,
            titles: [
                PageTitle.builder(
                    title: "Page 1",
                    subtitle: "Page 1 subtitle",
                    actions: [
                        TextButton(onPressed: (){}, child: const Text("Push Me")),
                    ],
                ),
                PageTitle.builder(
                    title: "Page 2",
                    subtitle: "Page 2 subtitle",
                ),
            ],
            pages: [
                PageContainer.childBuilder(
                    child: FirstPage(
                        controller: _pageScrollControllers[0],
                        titleHeight: widget.titleHeight,
                    ),
                ),
                PageContainer.childBuilder(
                    child: SecondPage(
                        controller: _pageScrollControllers[1],
                        titleHeight: widget.titleHeight,
                    ),
                ),
            ],
            pageScrollControllers: _pageScrollControllers,
        ),
    );
}
```

## Set your titles

The titles are constructed using the `PageTitleBuilder` builder function, to create a title builder, you can use:

```dart
PageTitle.builder(
    title: "Page 1",
    subtitle: "Page 1 subtitle",
    actions: [
        TextButton(onPressed: (){}, child: const Text("Push Me")),
    ],
)
```

The above generates a builder for title with:

- Title text `Page 1`
- Sub title text `Page 1 subtitle`
- Actions buttons
  - A text button with `Push Me` text

Include the title builder in the corresponding index of the `titles` list of the `PageSwiper` widget will make the title built for the corresponding page.

## Set your page

The pages are constructed using the `PageContainerBuilder` builder function.

To create a page builder, you shall first create your page widget. **In order to leave space for the title, add a `PageTitlePlaceholder` to your `CustomScrollView` slivers**.

Here is a page example, `AutomaticKeepAliveClientMixin` is for scroll position keeping, and setting `physics` to `const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())` will allow the title bar to stretch.

Also, **Remember to pass in the scroll controller and set it as your `CustomScrollView`'s controller**.

```dart
import 'package:cookbook/component/page_title_placeholder.dart';
import 'package:flutter/material.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({
    required this.controller,
    required this.titleHeight,
    super.key
  });

  final ScrollController controller;
  final double titleHeight;

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> with AutomaticKeepAliveClientMixin {
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
              // Your other slivers
            ],
          ),
        ),
      ],
    );

  }
}
```

Finally, use the `PageContainerBuilder` to include your page in the `PageSwiper`'s `pages` list:

```dart
PageContainer.childBuilder(
    child: DemoPage(
        controller: _pageScrollControllers[0],
        titleHeight: widget.titleHeight,
    )
)
```

## Parameters explained

The `PageSwiper` widget takes the following parameters:

| Name | Type | Is Required | Description |
|:----:|:----:|:-----------:|:-----------:|
| pageNum | `int` | Yes | Total page num |
| initialPage | `int` | 
| pageController | `PageController` | Yes | Page controller for the inner `PageView` widget |
| titleHeight | `double` | Yes | Height of title bar (normal state) |
| titleHeightCollapsed | `double` | Yes | Height of title bar (collapsed state) |
| titleFilterBackground | `Color` | No | The background color of the title bar when collapsed, default to `Colors.transparent` |
| titleFilterSigma | `double` | No | The blur sigma of the title bar when collapsed, default to `50` |
| blurByPage | `bool` | No | Whether the title bar is shared among pages, i.e. on top of all pages, or is created per page. Only small visual differences there are between the two approaches. Default to `false` |
| titleMaxExtend | `double` | No | The max extend the title bar can stretch, default to `1.2` |
| titles | `List<PageTitleBuilder>` | Yes | The builders of titles |
| pages | `List<PageContainerBuilder>` | Yes | The builder of pages |
| pageScrollControllers | `List<ScrollController>` | Yes | The scroll controllers for each page |
