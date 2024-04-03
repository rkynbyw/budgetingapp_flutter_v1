import 'package:budgeting_flutter_app_v1/presentation/provider/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/user_provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/screens/user_login_screens.dart';
import 'package:budgeting_flutter_app_v1/presentation/screens/home_screen.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/transaction_provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/budget_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        // Add other providers if needed
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurpleAccent,
          ),
        ),
        home: FutureBuilder<bool>(
          future: checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Menampilkan loading indicator jika masih menunggu hasil dari Future
              return CircularProgressIndicator();
            } else {
              // Jika sudah mendapatkan hasil dari Future, periksa status login
              return snapshot.data == true ? HomeScreen() : LoginPage();
            }
          },
        ),
      ),
    );
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    return isLogin;
  }
}
