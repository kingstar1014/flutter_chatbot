class HistoryModel {
  String? success;
  String? error;
  List<HistoryData>? data;

  HistoryModel({this.success, this.error, this.data});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      data = <HistoryData>[];
      json['data'].forEach((v) {
        data!.add(HistoryData.fromJson(v));
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

class HistoryData {
  String? categoryId;
  String? categoryName;
  String? subject;
  String? answer;
  String? categoryPhoto;

  HistoryData({this.categoryId, this.categoryName, this.subject, this.answer,this.categoryPhoto});

  HistoryData.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    subject = json['subject'] ?? '';
    answer = json['answer'];
    categoryPhoto = json['category_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['subject'] = subject;
    data['answer'] = answer;
    data['photo'] = categoryPhoto;
    return data;
  }
}
