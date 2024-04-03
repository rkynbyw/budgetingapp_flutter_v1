import 'dart:convert';

List<WalletModel> walletModelFromJson(String str) => List<WalletModel>.from(json.decode(str).map((x) => WalletModel.fromJson(x)));

String walletModelToJson(List<WalletModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WalletModel {
  int walletId;
  int walletTypeId;
  double balance;
  int userId;
  String name;
  WalletType walletType;
  String walletName;

  WalletModel({
    required this.walletId,
    required this.walletTypeId,
    required this.balance,
    required this.userId,
    required this.name,
    required this.walletType,
    required this.walletName,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    walletId: json["WalletID"],
    walletTypeId: json["WalletTypeID"],
    balance: json["Balance"] ?? 0,
    userId: json["UserID"],
    name: json["Name"],
    walletType: WalletType.fromJson(json["WalletType"]),
    walletName: json["WalletName"],
  );

  Map<String, dynamic> toJson() => {
    "WalletID": walletId,
    "WalletTypeID": walletTypeId,
    "Balance": balance,
    "UserID": userId,
    "Name": name,
    "WalletType": walletType.toJson(),
    "WalletName": walletName,
  };
}

class WalletType {
  int walletTypeId;
  String name;

  WalletType({
    required this.walletTypeId,
    required this.name,
  });

  factory WalletType.fromJson(Map<String, dynamic> json) => WalletType(
    walletTypeId: json["WalletTypeID"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "WalletTypeID": walletTypeId,
    "Name": name,
  };
}
