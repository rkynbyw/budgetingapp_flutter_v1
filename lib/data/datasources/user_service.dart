import '../models/user_auth_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'master.dart';

class LoginDataSource {

  Future<UserAuthModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${Master.baseUrl}/api/Users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Username': username,
        'Password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UserAuthModel.fromJson(data);
    } else {
      throw Exception('Failed to login (datasource)');
    }
  }

  Future<void> register(String email, String username, String fullName, String password) async {
    final response = await http.post(
      Uri.parse('${Master.baseUrl}/api/Users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Email': email,
        'Username': username,
        'FullName': fullName,
        'Password': password,
        'RePassword': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register (datasource)');
    }
  }
}