class Product {
  int id;
  int wholesalerId;
  String wholesalerName;
  String name;
  String code;
  int categoryId;
  String category;
  int brandId;
  String brand;
  String uom;
  int price;
  String account;
  String status;
  int addedBy;
  String createdAt;

  Product({
    required this.id,
    required this.wholesalerId,
    required this.wholesalerName,
    required this.name,
    required this.code,
    required this.categoryId,
    required this.category,
    required this.brandId,
    required this.brand,
    required this.uom,
    required this.price,
    required this.account,
    required this.status,
    required this.addedBy,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['ID'],
      wholesalerId: json['WHOLESALER_ID'],
      wholesalerName: json['WHOLESALER_NAME'],
      name: json['NAME'],
      code: json['CODE'],
      categoryId: json['CATEGORY_ID'],
      category: json['CATEGORY'],
      brandId: json['BRAND_ID'],
      brand: json['BRAND'],
      uom: json['UOM'],
      price: json['PRICE'],
      account: json['ACCOUNT'],
      status: json['STATUS'],
      addedBy: json['ADDED_BY'],
      createdAt: json['CREATED_AT'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'WHOLESALER_ID': wholesalerId,
      'WHOLESALER_NAME': wholesalerName,
      'NAME': name,
      'CODE': code,
      'CATEGORY_ID': categoryId,
      'CATEGORY': category,
      'BRAND_ID': brandId,
      'BRAND': brand,
      'UOM': uom,
      'PRICE': price,
      'ACCOUNT': account,
      'STATUS': status,
      'ADDED_BY': addedBy,
      'CREATED_AT': createdAt,
    };
  }
}
