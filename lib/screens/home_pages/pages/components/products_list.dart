import 'package:b2b_connect/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_horizontal.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
        builder: (context, productsProvider, _) {
      return Column(
        children: [
          for (var product in productsProvider.products)
            Material(
              child: InkWell(
                onTap: () {
                  print('Add to Cart');
                },
                child: ProductHorizontal(product: product),
              ),
            ),
        ],
      );
    });
  }
}
