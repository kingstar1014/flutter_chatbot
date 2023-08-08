class SuggestionModel {
  String? success;
  String? error;
  List<SuggestionData>? data;

  SuggestionModel({this.success, this.error, this.data});

  SuggestionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      data = <SuggestionData>[];
      json['data'].forEach((v) {
        data!.add(SuggestionData.fromJson(v));
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

class SuggestionData {
  int? id;
  String? name;
  int? categoryId;
  String? status;
  String? createdAt;
  String? updatedAt;

  SuggestionData({this.id, this.name, this.categoryId, this.status, this.createdAt, this.updatedAt});

  SuggestionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category_id'] = categoryId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
