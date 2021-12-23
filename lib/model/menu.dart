class Menu {
  int? id;
  String? name;
  String? createdAt;

  Menu({this.id, this.name, this.createdAt});
  Menu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
  }
}
