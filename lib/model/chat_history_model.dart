import 'package:quicklai/model/chat.dart';

class ChatHistoryModel {
  String? success;
  String? error;
  List<Chat>? data;

  ChatHistoryModel({this.success, this.error, this.data});

  ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      data = <Chat>[];
      json['data'].forEach((v) {
        data!.add(Chat.fromJson(v));
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


