class SubscriptionModel {
  String? success;
  String? error;
  List<SubscriptionData>? data;

  SubscriptionModel({this.success, this.error, this.data});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      data = <SubscriptionData>[];
      json['data'].forEach((v) {
        data!.add(SubscriptionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubscriptionData {
  int? id;
  String? name;
  String? description;
  String? androidSubscriptionKey;
  String? iosSubscriptionKey;
  String? price;
  String? discount;
  String? status;

  SubscriptionData(
      {this.id,
        this.name,
        this.description,
        this.androidSubscriptionKey,
        this.iosSubscriptionKey,
        this.price,
        this.discount,
        this.status});

  SubscriptionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    androidSubscriptionKey = json['android_subscription_key'];
    iosSubscriptionKey = json['ios_subscription_key'];
    price = json['price'];
    discount = json['discount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['android_subscription_key'] = androidSubscriptionKey;
    data['ios_subscription_key'] = iosSubscriptionKey;
    data['price'] = price;
    data['discount'] = discount;
    data['status'] = status;
    return data;
  }
}
