import 'package:budgeting_flutter_app_v1/presentation/provider/wallet_provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/screens/user_register.screens.dart';
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
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          suffixIcon: Icon(FontAwesomeIcons.user,
                              size: 17),
                        ),
                        validator: (value) {
                          if (value == null || value == 0) {
                            return 'Please enter username';
                          }
                          return null;
                        },

                      ),
                    ),
                    Container(
                        width: 250,
                        child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon:
                                    Icon(FontAwesomeIcons.eyeSlash, size: 17)
                                // suffixIcon: ,
                                // size: 17
                                ),
                          validator: (value) {
                            if (value == null || value == 0) {
                              return 'Please enter username';
                            }
                            return null;
                          },
                        )
                    ),
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
                    SizedBox(height: 10),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) =>
                          authProvider.isLoading
                              ? CircularProgressIndicator()
                              : Column(
                                children: [
                                  ElevatedButton(
                                      onPressed: () async{
                                        try {
                                          final authProvider =
                                          Provider.of<AuthProvider>(context, listen: false);
                                          final user = await authProvider.login(
                                            _usernameController.text,
                                            _passwordController.text,
                                          );

                                          Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
                                          Provider.of<BudgetProvider>(context, listen: false).fetchBudgets();
                                          Provider.of<WalletProvider>(context, listen: false).fetchWallets();

                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomeScreen(),
                                            ),
                                          );
                                        } catch (e) {

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Error'),
                                                content: Text(e.toString()),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(),
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(Colors
                                                .transparent),
                                        padding: MaterialStateProperty
                                            .all<EdgeInsetsGeometry>(EdgeInsets
                                                .zero), // Atur padding menjadi nol
                                        tapTargetSize: MaterialTapTargetSize
                                            .shrinkWrap,
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
                                              50),
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
                                  // if (authProvider.errorMessage.isNotEmpty)
                                  //   Padding(
                                  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  //     child: Text(
                                  //       authProvider.errorMessage,
                                  //       style: TextStyle(
                                  //         color: Colors.red,
                                  //         fontSize: 14.0,
                                  //       ),
                                  //     ),
                                  //   ),
                                ],
                              ),

                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dont have account?',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterPage()),
                            );
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    Text('Or login using Social Media',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600])),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Icon(FontAwesomeIcons.facebook,
                            color: Colors.purpleAccent),
                        SizedBox(width: 20,),
                        Icon(FontAwesomeIcons.google,
                            color: Colors.purpleAccent),
                        SizedBox(width: 20,),
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
