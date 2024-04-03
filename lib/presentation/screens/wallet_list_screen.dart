import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/wallet_provider.dart';
import 'package:budgeting_flutter_app_v1/data/models/wallet_model.dart';

class WalletListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Wallet'),
      ),
      body: Consumer<WalletProvider>(
        builder: (context, walletProvider, _) {
          final List<WalletModel> wallets = walletProvider.wallets;
          return ListView.builder(
            itemCount: wallets.length,
            itemBuilder: (context, index) {
              final wallet = wallets[index];
              return ListTile(
                title: Text(wallet.name),
                subtitle: Text('Balance: ${wallet.balance}'),
                // Tambahkan aksi lainnya di sini jika diperlukan
              );
            },
          );
        },
      ),
    );
  }
}
