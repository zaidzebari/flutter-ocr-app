class SubCategoryModel {
  int? id;
  int? menuId;
  String? pin;
  String? serial;
  String? price;
  String? createdOn;

  SubCategoryModel(
      {this.id,
      this.createdOn,
      this.pin,
      this.price,
      this.serial,
      this.menuId});
  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdOn = json['created_on'];
    menuId = json['menuId'];
    pin = json['pin'];
    serial = json['serial'];
    price = json['price'];
  }
}
