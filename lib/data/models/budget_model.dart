import 'dart:convert';

class BudgetModel {
  int? budgetID;
  DateTime? monthDate;
  double? amount;
  int? userID;
  int? transactionCategoryID;
  String? transactionCategoryName;
  double? expense;
  double? remainingAmount;

  BudgetModel({
    this.budgetID,
    this.monthDate,
    this.amount,
    this.userID,
    this.transactionCategoryID,
    this.transactionCategoryName,
    this.expense,
    this.remainingAmount,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> map) {
    return BudgetModel(
      budgetID: map['BudgetID'],
      monthDate: DateTime.parse(map['MonthDate']),
      amount: map['Amount']?.toDouble(),
      userID: map['UserID'],
      transactionCategoryID: map['TransactionCategoryID'],
      transactionCategoryName: map['TransactionCategoryName'],
      expense: map['Expense']?.toDouble(),
      remainingAmount: map['RemainingAmount']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BudgetID': budgetID,
      'MonthDate': monthDate?.toIso8601String(),
      'Amount': amount,
      'UserID': userID,
      'TransactionCategoryID': transactionCategoryID,
      'TransactionCategoryName': transactionCategoryName,
      'Expense': expense,
      'RemainingAmount': remainingAmount,
    };
  }

  @override
  String toString() {
    return 'BudgetModel{budgetID: $budgetID, monthDate: $monthDate, amount: $amount, userID: $userID, transactionCategoryID: $transactionCategoryID, transactionCategoryName: $transactionCategoryName, expense: $expense, remainingAmount: $remainingAmount}';
  }
}

List<BudgetModel> budgetModelsFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<BudgetModel>.from(data.map((item) => BudgetModel.fromJson(item)));
}

String budgetModelToJson(BudgetModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
