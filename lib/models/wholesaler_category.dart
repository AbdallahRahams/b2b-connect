class WholesalerCategory {
  int id;
  String name;

  WholesalerCategory({
    required this.id,
    required this.name,
  });

  factory WholesalerCategory.fromJson(Map<String, dynamic> json) {
    return WholesalerCategory(
      id: json['ID'],
      name: json['NAME'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'NAME': name,
    };
  }
}
