class GuestModel {
  String? success;
  String? error;
  String? message;
  Data? data;

  GuestModel({this.success, this.error, this.message, this.data});

  GuestModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? deviceId;
  String? writerLimit;
  String? chatLimit;
  String? imageLimit;

  Data({this.deviceId, this.writerLimit, this.chatLimit, this.imageLimit});

  Data.fromJson(Map<String, dynamic> json) {
    deviceId = json['device_id'];
    writerLimit = json['writer_limit'];
    chatLimit = json['chat_limit'];
    imageLimit = json['image_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['device_id'] = deviceId;
    data['writer_limit'] = writerLimit;
    data['chat_limit'] = chatLimit;
    data['image_limit'] = imageLimit;
    return data;
  }
}
