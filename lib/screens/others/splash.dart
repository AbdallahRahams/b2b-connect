import 'package:b2b_connect/components/custom_button.dart';
import 'package:b2b_connect/components/remove_scroll_glow.dart';
import 'package:b2b_connect/screens/others/welcome.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class Splash extends StatefulWidget {
  static const String route = '/splash';
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  CustomMaterialButton materialButton = CustomMaterialButton();
  CustomOutlineButton outlineButton = CustomOutlineButton();
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int pageCount = 2;
  @override
  initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10),
    );
    _pageController.addListener(() {
      _animationController.value = _pageController.page! / pageCount;
    });
    _animation = Tween(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.linear,
        ),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _labels = [
    {
      "label": "Wholesalers",
      "description": "Meet wholesalers who offer products at great prices.",
    },
    {
      "label": "Products",
      "description": "You can browse various products and choose the wholesaler with the best offer.",
    },
    {
      "label": "Orders",
      "description":
          "You can place an order and make a payment.",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SizedBox(
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: p5 * 2,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2.1,
                        child: AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, _) {
                            return Image.asset(
                              "assets/images/bg.png",
                              fit: BoxFit.fitHeight,
                              width: MediaQuery.of(context).size.height * 3 / 2,
                              alignment: Alignment(_animation.value, 0),
                            );
                          },
                        ),
                      ),
                      removeScrollGlow(
                        listChild: PageView(
                          controller: _pageController,
                          restorationId: "PageView",
                          children: List.generate(
                            pageCount + 1,
                            (index) => splashPage(context, index),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Wrap(
                        children: List.generate(
                          pageCount + 1,
                          (index) => Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: divider4,
                                width: 1,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        spacing: 5,
                      ),
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, animation) {
                          return Align(
                            alignment: Alignment(_animation.value, 0),
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: cPrimary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: p4, vertical: p4),
                  child: materialButton.createButton(
                    function: () {
                      Navigator.of(context).pushNamed(Welcome.route);
                    },
                    label: "Get started",
                    loadingLabel: "Starting...",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column splashPage(BuildContext context, int pageIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: divider4,
                  width: 0.5,
                ),
              ),
            ),
            // child: pageImages[pageIndex],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: p4, vertical: p4),
          // color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _labels[pageIndex]["label"]!,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(),
              ),
              const SizedBox(
                height: p2,
              ),
              Text(
                _labels[pageIndex]["description"]!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: cText3),
              ),
              const SizedBox(
                height: p5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
