class ProductCategory {
  int id;
  int wholesalerId;
  String code;
  String name;
  String status;
  String createdAt;

  ProductCategory({
    required this.id,
    required this.wholesalerId,
    required this.code,
    required this.name,
    required this.status,
    required this.createdAt,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['ID'],
      wholesalerId: json['WHOLESALER_ID'],
      code: json['CODE'],
      name: json['NAME'],
      status: json['STATUS'],
      createdAt: json['CREATED_AT'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'WHOLESALER_ID': wholesalerId,
      'CODE': code,
      'NAME': name,
      'STATUS': status,
      'CREATED_AT': createdAt,
    };
  }
}