import 'package:b2b_connect/screens/home_pages/pages/wholesaler_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/button_loading_indicator.dart';
import '../../constants.dart';
import '../../providers/wholesalers_provider.dart';
import 'components/wholesaler_horizontal.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchText = "";

  _searchWholesalers(String value) {
    WholesalersProvider wholesalersProvider =
    Provider.of<WholesalersProvider>(context, listen: false);
    wholesalersProvider.resetSearchWholesalerPage();
    wholesalersProvider.searchingWholesalers(value);
  }

  @override
  Widget build(BuildContext context) {
    WholesalersProvider wholesalersProvider =
    Provider.of<WholesalersProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.white,
        titleTextStyle: Theme.of(context).textTheme.headlineMedium!,
        iconTheme: Theme.of(context).iconTheme,
        automaticallyImplyLeading: true,
        centerTitle: centerTitle,
        elevation: 0.5,
        shadowColor: divider4,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          wholesalersProvider.resetSearchWholesalerPage();
          _searchWholesalers(searchText);
        },
        child: Column(
          children: [
            /// Search input
            Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: TextField(
                decoration: InputDecoration(
                  labelText:'Search',
                  suffixIcon: InkWell(
                      onTap: () {
                        _searchWholesalers(searchText);
                      },
                      child: const Icon(Icons.search_rounded)),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                onSubmitted: (value) {
                  _searchWholesalers(value);
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: wholesalersProvider.wholesalersScrollController,
                child: Column(
                  children: [
                    wholesalersProvider.searchPosts.isEmpty &&
                        wholesalersProvider.wholesalerSearch.isNotEmpty &&
                        wholesalersProvider.isSearchingWholesalerLoading == false
                        ? Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Center(
                        child: Text(
                          'No result found!',
                        ),
                      ),
                    )
                        : Container(),
                    wholesalersProvider.isSearchingWholesalerLoading &&
                        wholesalersProvider.searchPosts.isEmpty
                        ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: p4),
                      child: LoadingIndicator(
                        color: cPrimary,
                        size: 24,
                        stroke: 3,
                      ),
                    )
                        : ListView.builder(
                      controller: wholesalersProvider.wholesalersScrollController,
                      shrinkWrap: true,
                      itemCount: wholesalersProvider.searchPosts.length,
                      itemBuilder: (context, index) {
                        return Material(
                          child: InkWell(
                            onTap: () {
                              wholesalersProvider.setActiveWholesaler(
                                  wholesalersProvider.searchPosts[index]);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => const WholesalerScreen()),
                              );
                            },
                            child: WholesalerHorizontal(
                              wholesaler: wholesalersProvider.searchPosts[index],
                            ),
                          ),
                        );
                      },
                    ),
                    wholesalersProvider.isSearchingWholesalerLoading &&
                        wholesalersProvider.searchPosts.isNotEmpty
                        ? Center(
                      child: Container(
                        height: 60,
                        width: 60,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                          Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const CircularProgressIndicator(
                          color: cPrimary,
                        ),
                      ),
                    )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
