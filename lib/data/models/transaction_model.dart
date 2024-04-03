import 'dart:convert';

class TransactionModel {
  int? transactionID;
  int? walletID;
  int? transactionCategoryID;
  int? transactionType;
  double? amount;
  DateTime? date;
  String? description;
  int? userID;
  String? walletName;

  TransactionModel({
    this.transactionID,
    this.walletID,
    this.transactionCategoryID,
    this.transactionType,
    this.amount,
    this.date,
    this.description,
    this.userID,
    this.walletName,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> map) {
    return TransactionModel(
      transactionID: map["TransactionID"],
      walletID: map["WalletID"],
      transactionCategoryID: map["TransactionCategoryID"],
      transactionType: map["TransactionType"],
      amount: map["Amount"]?.toDouble(),
      date: map["Date"] != null ? DateTime.parse(map["Date"]) : null,
      description: map["Description"],
      userID: map["UserID"],
      walletName: map["WalletName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "TransactionID": transactionID,
      "WalletID": walletID,
      "TransactionCategoryID": transactionCategoryID,
      "TransactionType": transactionType,
      "Amount": amount,
      "Date": date?.toIso8601String(),
      "Description": description,
      "UserID": userID,
      "WalletName": walletName,
    };
  }

  @override
  String toString() {
    return
      'TransactionModel{transactionID: $transactionID, '
        'walletID: $walletID, '
        'transactionCategoryID: $transactionCategoryID, '
        'transactionType: $transactionType, '
        'amount: $amount, '
        'date: $date, '
        'description: $description, '
        'userID: $userID, '
        'walletName: $walletName}';
  }
}

List<TransactionModel> transactionModelsFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<TransactionModel>.from(data.map((item) => TransactionModel.fromJson(item)));
}

String transactionModelToJson(TransactionModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
