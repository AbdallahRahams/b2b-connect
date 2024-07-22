import 'package:b2b_connect/models/product.dart';

class ProductsPagination {
  int total;
  int page;
  int lastPage;
  List<Product> products;

  ProductsPagination({
    required this.total,
    required this.page,
    required this.lastPage,
    required this.products,
  });

  factory ProductsPagination.fromJson(Map<String, dynamic> json) {
    var productsList = json['data'] as List;
    List<Product> wholesalers =
        productsList.map((i) => Product.fromJson(i)).toList();
    return ProductsPagination(
      total: json['total'],
      page: json['page'],
      lastPage: json['last_page'],
      products: wholesalers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'last_page': lastPage,
      'data': products.map((i) => i.toJson()).toList(),
    };
  }
}
