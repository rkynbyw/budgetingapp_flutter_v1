import 'package:budgeting_flutter_app_v1/presentation/provider/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budgeting_flutter_app_v1/presentation/screens/user_login_screens.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/budget_provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

import '../provider/budget_provider.dart';
import '../provider/transaction_provider.dart';

class ProfileScreen extends StatelessWidget {
  Future<Map<String, String>> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String username = prefs.getString('username') ?? '';
    final String userStatus = prefs.getString('role') ?? '';
    return {'username': username, 'userStatus': userStatus};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(),
            ),
          ),
          Positioned(
            top: -350,
            left: -MediaQuery.of(context).size.width,
            right: -MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width * 7,
              height: 500,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF6D55BD),
                        Color(0xFFB700FF),
                      ])),
            ),
          ),
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: FutureBuilder<Map<String, String>>(
                future: _getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final username = snapshot.data!['username'];
                    return Text(
                      username!,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder<Map<String, String>>(
                  future: _getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final userStatus = snapshot.data!['userStatus'];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              'Username',
                              style: TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              snapshot.data!['username']!,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                            height: 10,
                            indent: 20,
                            endIndent: 20,
                          ),
                          ListTile(
                            title: Text(
                              'User Status',
                              style: TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              userStatus == 'user'
                                  ? 'Regular Member'
                                  : 'Premium Member',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 100),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Logout'),
                          content: Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.clear();
                                Provider.of<TransactionProvider>(context,
                                        listen: false)
                                    .clear();
                                Provider.of<BudgetProvider>(context,
                                        listen: false)
                                    .clear();

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.clear();
                                Provider.of<TransactionProvider>(context,
                                        listen: false)
                                    .clear();
                                Provider.of<BudgetProvider>(context,
                                        listen: false)
                                    .clear();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                              child: Text('Logout'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: 250,
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
