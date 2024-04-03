import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:budgeting_flutter_app_v1/data/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionDataSource {
  final String baseUrl = 'https://localhost:7018';

  Future _getUserId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    return userId;
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      int? userId = await _getUserId();
      final response = await http.get(Uri.parse('$baseUrl/api/Transactions/user/$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => TransactionModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }


  Future<TransactionModel> getTransactionById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/Transactions/$id'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return TransactionModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load transaction');
    }
  }

  Future<void> createTransaction(TransactionModel transaction) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Transactions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(transaction.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create transaction (datasource) & error code : ${response.statusCode}');
    }
  }

  Future<void> updateTransaction(int id, TransactionModel transaction) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/Transactions/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(transaction.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update transaction');
    }
  }

  Future<void> deleteTransaction(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/Transactions/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete transaction');
    }
  }
// Add other CRUD methods as needed
}
