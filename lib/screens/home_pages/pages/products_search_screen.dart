import 'package:b2b_connect/constants.dart';
import 'package:b2b_connect/providers/products_provider.dart';
import 'package:b2b_connect/providers/wholesalers_provider.dart';
import 'package:b2b_connect/screens/home_pages/pages/components/product_horizontal.dart';
import 'package:b2b_connect/screens/home_pages/pages/wholesaler_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/button_loading_indicator.dart';

class ProductsSearchScreen extends StatefulWidget {
  const ProductsSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProductsSearchScreen> createState() => _ProductsSearchScreenState();
}

class _ProductsSearchScreenState extends State<ProductsSearchScreen> {
  String searchText = "";

  _searchProducts(String value) {
    WholesalersProvider wholesalersProvider =
        Provider.of<WholesalersProvider>(context, listen: false);
    ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    productsProvider.resetSearchProductsPage();
    productsProvider.searchingWholesalers(
        value, wholesalersProvider.wholesaler.id);
  }

  @override
  Widget build(BuildContext context) {
    WholesalersProvider wholesalersProvider =
        Provider.of<WholesalersProvider>(context, listen: true);
    ProductsProvider productsProvider =
    Provider.of<ProductsProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(wholesalersProvider.wholesaler.name),
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
          productsProvider.resetSearchProductsPage();
          _searchProducts(searchText);
        },
        child: Column(
          children: [
            /// Search input
            Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: InkWell(
                      onTap: () {
                        _searchProducts(searchText);
                      },
                      child: const Icon(Icons.search_rounded)),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                onSubmitted: (value) {
                  _searchProducts(value);
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: productsProvider.productsScrollController,
                child: Column(
                  children: [
                    productsProvider.searchProducts.isEmpty &&
                        productsProvider.productSearch.isNotEmpty &&
                        productsProvider.isSearchingProductLoading ==
                                false
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
                            controller:
                            productsProvider.productsScrollController,
                            shrinkWrap: true,
                            itemCount: productsProvider.searchProducts.length,
                            itemBuilder: (context, index) {
                              return Material(
                                child: InkWell(
                                  onTap: () {
                                    productsProvider.setActiveProduct(
                                        productsProvider.searchProducts[index]);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) =>
                                              const WholesalerScreen()),
                                    );
                                  },
                                  child: ProductHorizontal(
                                    product:
                                    productsProvider.searchProducts[index],
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
