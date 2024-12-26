class IncomeExpenseModel {
  IncomeExpenseModel({
    this.name,
    this.date,
    this.amount,
    this.categoryName,
    this.isExpense,
  });

  IncomeExpenseModel.fromJson(dynamic json) {
    name = json['name'];
    date = json['date'];
    amount = json['amount'];
    categoryName = json['category_name'];
    isExpense = json['isExpense'];
  }
  String? name;
  String? date;
  num? amount;
  String? categoryName;
  String? isExpense;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['date'] = date;
    map['amount'] = amount;
    map['category_name'] = categoryName;
    map['isExpense'] = isExpense;
    return map;
  }
}
