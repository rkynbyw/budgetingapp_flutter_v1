import 'dart:convert';
import 'package:http/http.dart' as http;

class UserAuthModel {
  final String username;
  final String role;
  final String token;
  final int userId;

  UserAuthModel({
    required this.username,
    required this.role,
    required this.token,
    required this.userId
  });

  factory UserAuthModel.fromJson(Map<String, dynamic> json) {
    return UserAuthModel(
      username: json['Username'],
      role: json['Role'],
      token: json['Token'],
      userId: json['UserID']
    );
  }
}