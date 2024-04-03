import '../models/user_auth_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginDataSource {
  final String baseUrl = 'https://localhost:7018';

  Future<UserAuthModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Users/login'),
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
}