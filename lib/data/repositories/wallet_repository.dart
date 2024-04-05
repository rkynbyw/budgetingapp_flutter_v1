import 'package:budgeting_flutter_app_v1/data/datasources/wallet_datasource.dart';
import 'package:budgeting_flutter_app_v1/data/models/wallet_model.dart';

class WalletRepository{
  final WalletDatasource _datasource = WalletDatasource();

  Future<List<WalletModel>> getUserWallet() async{
    try{
      return await _datasource.getUserWallet();
    } catch (e){
      throw Exception('Failed to get user wallet: $e');
    }
  }

  Future<double> getUserBalance() async {
    try {
      final walletList = await _datasource.getUserWallet();
      // print(walletList);
      double totalBalance = 0;
      for (var wallet in walletList) {
        totalBalance += wallet.balance;
        // print (wallet.balance);
      }
      // print(totalBalance);
      return totalBalance;
    } catch (e) {
      throw Exception('Failed to get user balance: repository $e');
    }

  }
}