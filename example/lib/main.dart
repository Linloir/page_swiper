import 'package:flutter/material.dart';
import 'package:example/page/page1/first_page.dart';
import 'package:example/page/page2/recipe_category.dart';
import 'package:page_swiper/page_swiper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

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
            title: "All Photos",
            subtitle: "All photo page",
            actions: [
              TextButton(
                onPressed: (){},
                style: TextButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap), // make the button bottom-aligned with the title
                child: const Text("Select"),
              )
            ],
          ),
          PageTitle.builder(
            title: "Albums",
            subtitle: "Photo albums",
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
}
