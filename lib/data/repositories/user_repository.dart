import 'dart:convert';
import 'package:http/http.dart' as http;

import '../datasources/user_service.dart';
import '../models/user_auth_model.dart';

class LoginRepository {
  final LoginDataSource _dataSource = LoginDataSource();

  Future<UserAuthModel> login(String username, String password) async {
    try {
      final userModel = await _dataSource.login(username, password);
      return userModel;
    } catch (e) {
      throw Exception('Failed to login (repo): $e');
    }
  }
}