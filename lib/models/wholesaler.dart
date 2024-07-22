class Wholesaler {
  int id;
  int categoryId;
  String categoryName;
  String name;
  String bio;
  String profileImagePath;
  String phone;
  String email;
  String address;
  String locationName;
  String type;
  String status;
  int feature;
  String createdAt;

  Wholesaler({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.bio,
    required this.profileImagePath,
    required this.phone,
    required this.email,
    required this.address,
    required this.locationName,
    required this.type,
    required this.status,
    required this.feature,
    required this.createdAt,
  });

  factory Wholesaler.fromJson(Map<String, dynamic> json) {
    return Wholesaler(
      id: json['ID'],
      categoryId: json['CATEGORY_ID'],
      categoryName: json['CATEGORY_NAME'],
      name: json['NAME'],
      bio: json['BIO'],
      profileImagePath: json['PROFILE_IMAGE_PATH'],
      phone: json['PHONE'],
      email: json['EMAIL'],
      address: json['ADDRESS'],
      locationName: json['LOCATION_NAME'],
      type: json['TYPE'],
      status: json['STATUS'],
      feature: json['FEATURE'],
      createdAt: json['CREATED_AT'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'CATEGORY_ID': categoryId,
      'CATEGORY_NAME': categoryName,
      'NAME': name,
      'BIO': bio,
      'PROFILE_IMAGE_PATH': profileImagePath,
      'PHONE': phone,
      'EMAIL': email,
      'ADDRESS': address,
      'LOCATION_NAME': locationName,
      'TYPE': type,
      'STATUS': status,
      'FEATURE': feature,
      'CREATED_AT': createdAt,
    };
  }
}
