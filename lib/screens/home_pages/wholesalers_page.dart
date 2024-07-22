import 'package:b2b_connect/screens/home_pages/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/wholesalers_provider.dart';
import 'components/category_chip.dart';
import 'components/separator.dart';
import 'components/tag_chip.dart';
import 'components/wholesalers_list.dart';

class HomeActiveTabProvider with ChangeNotifier {
  int _activeTab = 0;
  PageController _pageController = PageController(initialPage: 0);

  int getActiveTab() => _activeTab;

  PageController getActivePage() => _pageController;

  setActiveTab({required int index}) {
    _activeTab = index;
    notifyListeners();
    changeActivePage(index);
  }

  changeActivePage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class WholesalersPage extends StatefulWidget {
  const WholesalersPage({Key? key}) : super(key: key);

  @override
  _WholesalersPageState createState() => _WholesalersPageState();
}

class _WholesalersPageState extends State<WholesalersPage> {
  @override
  void initState() {
    initialFunctions();
    super.initState();
  }

  initialFunctions() {
    WholesalersProvider wholesalersProvider =
    Provider.of<WholesalersProvider>(context, listen: false);
    wholesalersProvider.initialFunctions();
  }


  @override
  Widget build(BuildContext context) {
    WholesalersProvider wholesalersProvider =
    Provider.of<WholesalersProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("$appName"),
          titleTextStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontFamily: "Gilroy",
            letterSpacing: -1,
            color: Theme.of(context).textTheme.headlineSmall!.color,
          ),
          backgroundColor: Colors.white,
          iconTheme: Theme.of(context).iconTheme,
          automaticallyImplyLeading: false,
          centerTitle: centerTitle,
          elevation: 0.5,
          shadowColor: divider4,
          actions: [
            Consumer<WholesalersProvider>(builder: (context, wholesalersProvider, _) {
              return IconButton(
                onPressed: () {
                  wholesalersProvider.resetSearchWholesalerPage();
                  wholesalersProvider.searchPostScrollControl();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchScreen()),
                  );
                },
                icon: Icon(Icons.search),
              );
            }),
          ],
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                initialFunctions();
              },
              child: SingleChildScrollView(
                controller: wholesalersProvider.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Separator(),
                    ///
                    /// WHOLESALER CATEGORIES
                    ///
                    wholesalersProvider.isWholesalerCategoryLoading
                        ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(p1),
                          color: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                    )
                        : wholesalersProvider.wholesalerCategories.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        restorationId: "wholesalerCategories",
                        key: const PageStorageKey("wholesalerCategories"),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var wholesalerCategory in wholesalersProvider.wholesalerCategories)
                              CategoryChip(
                                  label: wholesalerCategory.name,
                                  isActive: wholesalersProvider.activeWholesalerCategoryID ==
                                      wholesalerCategory.id
                                      ? true
                                      : false,
                                  onTap: () {
                                    wholesalersProvider.setActiveWholesalerCategory(wholesalerCategory.id);
                                  }),
                          ],
                        ),
                      ),
                    )
                        : TagChip(
                      label: 'Not found!',
                      onTap: wholesalersProvider.fetchWholesalerCategories,
                    ),
                    const Separator(),

                    ///
                    /// WHOLESALERS
                    ///
                    wholesalersProvider.isInitialWholesalerLoading ?
                    loadingWholesalersShimmer() :
                    const WholesalersList(),
                    wholesalersProvider.isWholesalerLoading
                        ? loadingWholesalersShimmer()
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Column loadingWholesalersShimmer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: ClipRRect(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(defaultPadding)),
                    child: Container(
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 25,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(p4),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 25,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(p4),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 25,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(p4),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
        const Separator(),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: ClipRRect(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(defaultPadding)),
                    child: Container(
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 25,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(p4),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 25,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(p4),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 25,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(p4),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
        const Separator(),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: ClipRRect(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(defaultPadding)),
                    child: Container(
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 25,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(p4),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 25,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(p4),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 25,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(p4),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
        const Separator(),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: ClipRRect(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(defaultPadding)),
                    child: Container(
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 25,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(p4),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 25,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(p4),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          height: 25,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(p4),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
        const Separator(),
      ],
    );
  }
}
