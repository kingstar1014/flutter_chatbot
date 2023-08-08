class CategorySuggestionModel {
  int? id;
  String? name;
  String? icon;

  CategorySuggestionModel({this.id, this.name, this.icon});

  CategorySuggestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon'] = icon;
    return data;
  }
}
