import 'package:b2b_connect/models/wholesaler.dart';

class WholesalersPagination {
  int total;
  int page;
  int lastPage;
  List<Wholesaler> wholesalers;

  WholesalersPagination({
    required this.total,
    required this.page,
    required this.lastPage,
    required this.wholesalers,
  });

  factory WholesalersPagination.fromJson(Map<String, dynamic> json) {
    var wholesalersList = json['data'] as List;
    List<Wholesaler> wholesalers =
        wholesalersList.map((i) => Wholesaler.fromJson(i)).toList();
    return WholesalersPagination(
      total: json['total'],
      page: json['page'],
      lastPage: json['last_page'],
      wholesalers: wholesalers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'last_page': lastPage,
      'data': wholesalers.map((i) => i.toJson()).toList(),
    };
  }
}
