import 'package:budgeting_flutter_app_v1/presentation/provider/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/user_provider.dart';

import '../../data/models/user_auth_model.dart';
import '../../data/repositories/user_repository.dart';
import '../provider/budget_provider.dart';
import '../provider/transaction_provider.dart';
import 'home_screen.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [
              Color(0xFF6D55BD),
              Color(0xFFB700FF),
            ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            SizedBox(height: 35),
            Text('Budgeting App',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 500,
              width: 350,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text('Hello',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Please login to your account',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 250,
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          suffixIcon: Icon(FontAwesomeIcons.user,
                              size: 17), // Atur ukuran ikon di sini
                        ),
                      ),
                    ),
                    Container(
                        width: 250,
                        child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon:
                                    Icon(FontAwesomeIcons.eyeSlash, size: 17)
                                // suffixIcon: ,
                                // size: 17
                                ))),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 40, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Forget Password',
                              style: TextStyle(color: Colors.purpleAccent[700]))
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) =>
                          authProvider.isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () async {
                                    final authProvider =
                                        Provider.of<AuthProvider>(context,
                                            listen: false);
                                    final user = await authProvider.login(
                                      _usernameController.text,
                                      _passwordController.text,
                                    );
                                    // After successful login, navigate to home screen
                                    Provider.of<TransactionProvider>(context,
                                            listen: false)
                                        .fetchTransactions();
                                    Provider.of<BudgetProvider>(context,
                                            listen: false)
                                        .fetchBudgets();
                                    Provider.of<WalletProvider>(context,
                                        listen: false)
                                        .fetchWallets();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(Colors
                                            .transparent), // Atur warna latar belakang transparan
                                    padding: MaterialStateProperty
                                        .all<EdgeInsetsGeometry>(EdgeInsets
                                            .zero), // Atur padding menjadi nol
                                    tapTargetSize: MaterialTapTargetSize
                                        .shrinkWrap, // Atur ukuran target tap agar sesuai dengan konten tombol
                                  ),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF6D55BD),
                                          Color(0xFFB700FF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          50), // Atur sudut tombol
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 250,
                                      padding: EdgeInsets.all(12.0),
                                      child: Text('Login',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text('Or login using Social Media',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600])),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(FontAwesomeIcons.facebook,
                            color: Colors.purpleAccent),
                        Icon(FontAwesomeIcons.google,
                            color: Colors.purpleAccent),
                        Icon(FontAwesomeIcons.apple,
                            color: Colors.purpleAccent),
                      ],
                    )
                  ]),
            )
          ],
        ),
      ),
    ));
  }
}

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   final LoginRepository _loginRepository = LoginRepository();
//
//   bool _isLoading = false;
//
//   Future<void> _login() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       final UserAuthModel user = await _loginRepository.login(
//         _usernameController.text,
//         _passwordController.text,
//       );
//
//       // Simpan token ke SharedPreferences
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', user.token);
//       await prefs.setInt('userId', user.userId);
//       await prefs.setString('username', user.username);
//       await prefs.setString('role', user.role);
//
//       // Cetak informasi user
//       print('UserId: ${user.userId}');
//       print('Username: ${prefs.getString('username')}');
//       print('Role: ${user.role}');
//       print('Token: ${prefs.getString('token')}');
//
//       // Navigasi ke halaman beranda setelah login berhasil
//       Provider.of<TransactionProvider>(context, listen: false)
//           .fetchTransactions();
//       Provider.of<BudgetProvider>(context, listen: false).fetchBudgets();
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => HomeScreen()));
//     } catch (e) {
//       print('Error: $e');
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Error'),
//             content: Text('Failed to login. Please try again.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }
