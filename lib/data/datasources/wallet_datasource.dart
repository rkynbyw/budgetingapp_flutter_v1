import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:budgeting_flutter_app_v1/data/models/wallet_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletDatasource{
  final String baseUrl = 'https://localhost:7018';

  Future<Map<String, String>> _getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      return {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'};
    } else {
      throw Exception('Token not found');
    }
  }

  Future _getUserId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    return userId;
  }
  // https://localhost:7018/api/Wallets/user/15
  // Future<List<WalletModel>> getUserWallet() async {
  //   int? userId = await _getUserId();
  //   final response = await http.get(
  //       Uri.parse('$baseUrl/api/Wallets/user/$userId'),
  //       headers: await _getHeaders());
  //   if (response.statusCode == 200) {
  //     final List<dynamic> jsonData = json.decode(response.body);
  //     return jsonData.map((json) => WalletModel.fromJson(json)).toList();
  //
  //   } else if (response.statusCode == 401) {
  //     throw Exception('Unauthorized');
  //   }
  //   else {
  //     throw Exception('Failed to load balance datasource : ${response.statusCode}');
  //   }
  // }

  Future<List<WalletModel>> getUserWallet() async {
    int? userId = await _getUserId();
    final response = await http.get(
        Uri.parse('$baseUrl/api/Wallets/user/$userId'),
        headers: await _getHeaders());
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      print(jsonData); // Print JSON data for checking
      final List<dynamic> walletData = jsonData as List<dynamic>;
      return walletData.map((json) => WalletModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to load balance datasource : ${response.statusCode}');
    }
  }


}