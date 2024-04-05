import 'package:budgeting_flutter_app_v1/presentation/screens/user_login_screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/user_provider.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF6D55BD), Color(0xFFB700FF)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text(
                'Budgeting App',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 35),
              Container(
                height: 500,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      'Register',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 250,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          suffixIcon: Icon(
                            Icons.email,
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          suffixIcon: Icon(
                            Icons.person,
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TextField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          suffixIcon: Icon(
                            Icons.person,
                            size: 17,
                          ),
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
                          suffixIcon: Icon(
                            Icons.lock,
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) => ElevatedButton(
                        onPressed: () async {
                          await authProvider.register(
                            _emailController.text,
                            _usernameController.text,
                            _fullNameController.text,
                            _passwordController.text,
                          );

                          if (authProvider.errorMessage.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Registration successful!'),
                              ),
                            );
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.of(context).pop();
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(authProvider.errorMessage),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors
                              .transparent),
                          padding: MaterialStateProperty
                              .all<EdgeInsetsGeometry>(EdgeInsets
                              .zero),
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
                            child: Text('Register',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
