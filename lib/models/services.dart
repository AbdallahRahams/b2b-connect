class Services {
  int? count;
  List<Service>? service;

  Services({this.count, this.service});

  Services.fromJson(Map<String, dynamic> json) {
    count = json['COUNT'];
    if (json['DATA'] != null) {
      service = <Service>[];
      json['DATA'].forEach((v) {
        service!.add(Service.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['COUNT'] = this.count;
    if (this.service != null) {
      data['DATA'] = this.service!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Service {
  int? id;
  String? title;
  String? description;
  String? status;
  String? type;
  int? amount;
  String? currencyType;
  String? createdAt;
  String? updatedAt;

  Service(
      {this.id,
      this.title,
      this.description,
      this.status,
      this.type,
      this.amount,
      this.currencyType,
      this.createdAt,
      this.updatedAt});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    title = json['TITLE'];
    description = json['DESCRIPTION'];
    status = json['STATUS'];
    type = json['TYPE'];
    amount = json['AMOUNT'];
    currencyType = json['CURRENT_TYPE'];
    createdAt = json['CREATED_AT'];
    updatedAt = json['UPDATED_AT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = this.id;
    data['TITLE'] = this.title;
    data['DESCRIPTION'] = this.description;
    data['STATUS'] = this.status;
    data['TYPE'] = this.type;
    data['AMOUNT'] = this.amount;
    data['CURRENT_TYPE'] = this.currencyType;
    data['CREATED_AT'] = this.createdAt;
    data['UPDATED_AT'] = this.updatedAt;
    return data;
  }
}
