import 'package:b2b_connect/providers/products_provider.dart';
import 'package:b2b_connect/providers/wholesalers_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../components/category_chip.dart';
import '../components/separator.dart';
import '../components/tag_chip.dart';
import 'components/products_list.dart';
import 'products_search_screen.dart';

class WholesalerScreen extends StatefulWidget {
  const WholesalerScreen({Key? key}) : super(key: key);

  @override
  State<WholesalerScreen> createState() => _WholesalerScreenState();
}

class _WholesalerScreenState extends State<WholesalerScreen> {
  @override
  void initState() {
    initialFunctions();
    super.initState();
  }

  initialFunctions() {
    WholesalersProvider wholesalersProvider =
        Provider.of<WholesalersProvider>(context, listen: false);
    ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    productsProvider.initialFunctions(wholesalersProvider.wholesaler.id);
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
          actions: [
            Consumer<ProductsProvider>(
                builder: (context, productsProvider, _) {
              return IconButton(
                onPressed: () {
                  productsProvider.resetSearchProductsPage();
                  productsProvider.searchPostScrollControl(wholesalersProvider.wholesaler.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductsSearchScreen()),
                  );
                },
                icon: Icon(Icons.search),
              );
            }),
          ]),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              initialFunctions();
            },
            child: SingleChildScrollView(
              controller: productsProvider.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Separator(),

                  ///
                  /// PRODUCTS CATEGORIES
                  ///
                  productsProvider.isProductCategoryLoading
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
                      : productsProvider.productCategories.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                restorationId: "productCategories",
                                key: const PageStorageKey(
                                    "productCategories"),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (var productCategory
                                        in productsProvider
                                            .productCategories)
                                      CategoryChip(
                                          label: productCategory.name,
                                          isActive: productsProvider
                                                      .activeProductCategoryID ==
                                                  productCategory.id
                                              ? true
                                              : false,
                                          onTap: () {
                                            productsProvider
                                                .setActiveProductCategory(
                                                    productCategory.id, wholesalersProvider.wholesaler.id);
                                          }),
                                  ],
                                ),
                              ),
                            )
                          : TagChip(
                              label: 'Not found!',
                              onTap:
                              productsProvider.fetchProductCategories(wholesalersProvider.wholesaler.id),
                            ),
                  const Separator(),

                  ///
                  /// PRODUCTS
                  ///
                  productsProvider.isInitialProductLoading
                      ? loadingProductsShimmer()
                      : const ProductsList(),
                  productsProvider.isProductLoading
                      ? loadingProductsShimmer()
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Column loadingProductsShimmer() {
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
