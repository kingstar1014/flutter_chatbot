class CharactersModel {
  String? success;
  String? error;
  List<CharactersData>? data;

  CharactersModel({this.success, this.error, this.data});

  CharactersModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      data = <CharactersData>[];
      json['data'].forEach((v) {
        data!.add(CharactersData.fromJson(v));
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

class CharactersData {
  int? id;
  String? name;
  String? description;
  String? prompt;
  String? photo;
  String? lock;

  CharactersData(
      {this.id,
      this.name,
      this.description,
      this.prompt,
      this.photo,
      this.lock});

  CharactersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    prompt = json['prompt'];
    photo = json['photo'];
    lock = json['lock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['prompt'] = prompt;
    data['name'] = name;
    data['photo'] = photo;
    data['lock'] = lock;
    return data;
  }
}
