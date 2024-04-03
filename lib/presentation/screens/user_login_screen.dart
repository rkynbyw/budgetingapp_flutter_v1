// import 'package:budgeting_flutter_app_v1/presentation/provider/budget_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:budgeting_flutter_app_v1/data/repositories/user_repository.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:budgeting_flutter_app_v1/data/models/user_auth_model.dart';
// import 'package:budgeting_flutter_app_v1/presentation/screens/home_screen.dart';
//
// import '../provider/transaction_provider.dart';
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
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
//       await prefs.setBool('isLogin', true);
//
//       // Cetak informasi user
//       print('UserId: ${user.userId}');
//       print('Username: ${prefs.getString('username')}');
//       print('Role: ${user.role}');
//       print('Token: ${prefs.getString('token')}');
//
//
//       // Navigasi ke halaman beranda setelah login berhasil
//       Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
//       Provider.of<BudgetProvider>(context, listen: false).fetchBudgets();
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(32.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 100),
//               // Image.asset(
//               //   'assets/images/logo.png', // Ganti dengan path logo Anda
//               //   height: 150,
//               //   width: 150,
//               // ),
//               SizedBox(height: 40),
//               TextField(
//                 controller: _usernameController,
//                 decoration: InputDecoration(
//                   labelText: 'Username',
//                   prefixIcon: Icon(Icons.person),
//                 ),
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   prefixIcon: Icon(Icons.lock),
//                 ),
//               ),
//               SizedBox(height: 40),
//               _isLoading
//                   ? CircularProgressIndicator()
//                   : ElevatedButton(
//                 onPressed: _login,
//                 child: Text(
//                   'Login',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
