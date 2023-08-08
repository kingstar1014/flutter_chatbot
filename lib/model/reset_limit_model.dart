class ResetLimitModel {
  String? success;
  String? error;
  ResetLimitData? data;

  ResetLimitModel({this.success, this.error, this.data});

  ResetLimitModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    data = json['data'] != null ? ResetLimitData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ResetLimitData {
  String? writerLimit;
  String? chatLimit;
  String? imageLimit;

  ResetLimitData({this.writerLimit, this.chatLimit, this.imageLimit});

  ResetLimitData.fromJson(Map<String, dynamic> json) {
    writerLimit = json['writer_limit'];
    chatLimit = json['chat_limit'];
    imageLimit = json['image_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['writer_limit'] = writerLimit;
    data['chat_limit'] = chatLimit;
    data['image_limit'] = imageLimit;
    return data;
  }
}
