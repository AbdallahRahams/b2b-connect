import 'dart:collection';
import 'dart:convert';
import 'package:b2b_connect/models/product_category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/product.dart';
import '../models/products_pagination.dart';

class ProductsProvider extends ChangeNotifier {
  /// WHOLESALER PRODUCTS PAGE
  bool _isInitialProductLoading = false;
  bool _isProductCategoryLoading = false;
  bool _isProductLoading = false;
  final List<ProductCategory> _productCategories = [];
  final List<Product> _products = [];
  int _activeProductCategoryID = 0;
  final String _sort = "desc";
  int _page = 1;
  int _limit = 10;
  ProductsPagination _productsPagination =
  ProductsPagination(page: 0, total: 0, lastPage: 0, products: []);
  final ScrollController _scrollController = ScrollController();
  late Product _product;

  /// SEARCH WHOLESALER PRODUCT PAGE
  bool _isSearchingProductLoading = false;
  ProductsPagination _searchProductsPagination =
  ProductsPagination(page: 0, total: 0, lastPage: 0, products: []);
  final List<Product> _searchProducts = [];
  final ScrollController _productsScrollController = ScrollController();
  String _productSearch = "";
  String _productSort = "desc";
  int _productPage = 1;
  int _productLimit = 10;

  ///
  late ProductCategory _productCategory;

  /// HOME GETTERS
  bool get isProductCategoryLoading => _isProductCategoryLoading;

  bool get isProductLoading => _isProductLoading;

  UnmodifiableListView<ProductCategory> get productCategories =>
      UnmodifiableListView(_productCategories);

  UnmodifiableListView<Product> get products =>
      UnmodifiableListView(_products);

  int get activeProductCategoryID => _activeProductCategoryID;

  ProductsPagination get productsPagination => _productsPagination;

  ScrollController get scrollController => _scrollController;

  Product get product => _product;

  bool get isInitialProductLoading => _isInitialProductLoading;

  /// SEARCH GETTERS
  ProductsPagination get searchPostPaginationResult =>
      _searchProductsPagination;

  bool get isSearchingProductLoading => _isSearchingProductLoading;

  UnmodifiableListView<Product> get searchProducts =>
      UnmodifiableListView(_searchProducts);

  String get productSearch => _productSearch;

  ScrollController get productsScrollController =>
      _productsScrollController;

  ProductCategory get productCategory => _productCategory;

  initialFunctions(int wholesalerID) {
    _page = 1;
    _limit = 10;
    fetchProductCategories(wholesalerID);
    scrollControl(wholesalerID);
  }

  fetchProductCategories(int wholesalerID) async {
    try {
      _isProductCategoryLoading = true;
      _isInitialProductLoading = true;
      http.Response categoriesResponse;
      categoriesResponse = await http.get(
        Uri.parse('$wholesalersURL/api/v1/product/categories?wholesaler=$wholesalerID'),
        headers: {'Content-Type': 'application/json'},
      );
      if (categoriesResponse.statusCode == 200) {
        var categoriesJson = json.decode(utf8.decode(categoriesResponse.bodyBytes));
        _productCategories.clear();
        categoriesJson.forEach((menu) =>
        {_productCategories.add(ProductCategory.fromJson(menu))});
        if (_productCategories.isNotEmpty) {
          _activeProductCategoryID = _productCategories[0].id;
          fetchInitialProducts(wholesalerID);
        }
        _isProductCategoryLoading = false;
        notifyListeners();
        return;
      } else if (categoriesResponse.statusCode == 401) {
        _isProductCategoryLoading = false;
        notifyListeners();
        return;
      } else {
        _isProductCategoryLoading = false;
        notifyListeners();
        return;
      }
    } catch (e) {
      _isProductCategoryLoading = false;
      notifyListeners();
      return;
    }
  }

  fetchInitialProducts(int wholesalerID) async {
    try {
      _isInitialProductLoading = true;
      notifyListeners();
      http.Response productsResponse;
      productsResponse = await http.get(
        Uri.parse(
            "$wholesalersURL/api/v1/products?category=$_activeProductCategoryID&sort=$_sort&page=$_page&limit=$_limit&wholesaler=$wholesalerID"),
        headers: {'Content-Type': 'application/json'},
      );

      if (productsResponse.statusCode == 200) {
        var productsJson =
        json.decode(utf8.decode(productsResponse.bodyBytes));
        _productsPagination =
            ProductsPagination.fromJson(productsJson);
        _products.clear();
        for (var product in _productsPagination.products) {
          _products.add(product);
        }
        _isInitialProductLoading = false;
        notifyListeners();
        return;
      } else if (productsResponse.statusCode == 401) {
        _isInitialProductLoading = false;
        notifyListeners();
        return;
      } else {
        _isInitialProductLoading = false;
        notifyListeners();
        return;
      }
    } catch (e) {
      _isInitialProductLoading = false;
      notifyListeners();
      return;
    }
  }

  scrollControl(int wholesalerID) {
    _scrollController.addListener(
          () async {
        if (_isProductLoading == false) {
          if (_productsPagination.lastPage >= _page) {
            _page++;
            fetchProductPagination(wholesalerID);
          }
        }
      },
    );
  }

  fetchProductPagination(int wholesalerID) async {
    try {
      _isProductLoading = true;
      notifyListeners();
      http.Response postsResponse;
      postsResponse = await http.get(
        Uri.parse(
            "$wholesalersURL/api/v1/products?category=$_activeProductCategoryID&sort=$_sort&page=$_page&limit=$_limit&wholesaler=$wholesalerID"),
        headers: {'Content-Type': 'application/json'},
      );
      if (postsResponse.statusCode == 200) {
        var productJson = json.decode(utf8.decode(postsResponse.bodyBytes));
        _productsPagination = ProductsPagination.fromJson(productJson);
        for (var post in _productsPagination.products) {
          _products.add(post);
        }

        _isProductLoading = false;
        notifyListeners();
        return;
      } else if (postsResponse.statusCode == 401) {
        _isProductLoading = false;
        notifyListeners();
        return;
      } else {
        _isProductLoading = false;
        notifyListeners();
        return;
      }
    } catch (e) {
      _isProductLoading = false;
      notifyListeners();
      return;
    }
  }

  setActiveProductCategory(int wholesalerCategoryID, int wholesalerID) {
    _page = 1;
    _limit = 10;
    _activeProductCategoryID = wholesalerCategoryID;
    _isInitialProductLoading = true;
    notifyListeners();
    fetchInitialProducts(wholesalerID);
  }

  setActiveProduct(Product p) {
    _product = p;
    notifyListeners();
  }

  resetSearchProductsPage() {
    _productSearch = "";
    _productSort = "desc";
    _productPage = 1;
    _productLimit = 10;
    _searchProducts.clear();
  }

  searchingWholesalers(String value, int wholesalerID) {
    _productSearch = value;
    searchProductsPagination(wholesalerID);
  }

  searchProductsPagination(int wholesalerID, [isFromScrolling = false]) async {
    try {
      if (isFromScrolling == false) {
        _searchProducts.clear();
      }
      _isSearchingProductLoading = true;
      notifyListeners();
      http.Response productResponse;
      productResponse = await http.get(
        Uri.parse(
            "$wholesalersURL/api/v1/products?search=$_productSearch&sort=$_productSort&page=$_productPage&limit=$_productLimit&wholesaler=$wholesalerID"),
        headers: {'Content-Type': 'application/json'},
      );

      if (productResponse.statusCode == 200) {
        var wholesalersJson =
        json.decode(utf8.decode(productResponse.bodyBytes));
        _searchProductsPagination =
            ProductsPagination.fromJson(wholesalersJson);
        for (var product in _searchProductsPagination.products) {
          _searchProducts.add(product);
        }

        _isSearchingProductLoading = false;
        notifyListeners();
        return;
      } else if (productResponse.statusCode == 401) {
        _isSearchingProductLoading = false;
        notifyListeners();
        return;
      } else {
        _isSearchingProductLoading = false;
        notifyListeners();
        return;
      }
    } catch (e) {
      _isSearchingProductLoading = false;
      notifyListeners();
      return;
    }
  }

  searchPostScrollControl(int wholesalerID) {
    _productsScrollController.addListener(
          () async {
        if (_isSearchingProductLoading == false) {
          if (_searchProductsPagination.lastPage >= _productPage) {
            _productPage++;
            searchProductsPagination(wholesalerID, true);
          }
        }
      },
    );
  }

  activateProductCategory(ProductCategory c) {
    _productCategory = c;
    _products.clear();
    notifyListeners();
  }
}
