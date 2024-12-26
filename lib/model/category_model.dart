class CategoryModel {
  CategoryModel({
    this.name,
    this.isExpense,
    this.img,
  });

  CategoryModel.fromJson(dynamic json) {
    name = json['name'];
    isExpense = json['isExpense'];
    img = json['img'];
  }
  String? name;
  String? isExpense;
  String? img;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['isExpense'] = isExpense;
    map['img'] = img;
    return map;
  }
}
