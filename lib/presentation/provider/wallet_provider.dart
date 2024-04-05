import 'package:flutter/material.dart';
import 'package:budgeting_flutter_app_v1/data/models/wallet_model.dart';
import 'package:budgeting_flutter_app_v1/data/repositories/wallet_repository.dart';

class WalletProvider with ChangeNotifier {
  final WalletRepository _walletRepository = WalletRepository();
  late List<WalletModel> _wallets;

  List<WalletModel> get wallets => _wallets;

  WalletProvider() {
    _wallets = [];
    fetchWallets();
  }

  Future<void> fetchWallets() async {
    try {
      List<WalletModel> fetchedWallets = await _walletRepository.getUserWallet();
      _wallets = fetchedWallets;
      notifyListeners();
    } catch (e) {
      print('Error fetching wallets: $e');
    }
  }
}
