class LanguageModel {
  String? success;
  String? error;
  List<LanguageData>? data;

  LanguageModel({this.success, this.error, this.data});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      data = <LanguageData>[];
      json['data'].forEach((v) {
        data!.add(LanguageData.fromJson(v));
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

class LanguageData {
  int? id;
  String? name;
  String? code;
  String? photo;
  String? isRtl;
  String? status;

  LanguageData({this.id, this.name, this.code, this.photo, this.isRtl, this.status});

  LanguageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    photo = json['photo'];
    isRtl = json['is_rtl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['photo'] = photo;
    data['is_rtl'] = isRtl;
    data['status'] = status;
    return data;
  }
}
