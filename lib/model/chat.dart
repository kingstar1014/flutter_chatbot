class Chat {
  String? msg;
  String? chat;

  Chat({
    required this.msg,
    required this.chat,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    chat = json['chat'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat'] = chat;
    data['msg'] = msg;
    return data;
  }
}
