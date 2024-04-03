import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:budgeting_flutter_app_v1/data/models/budget_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetDataSource {
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

  Future<List<BudgetModel>> getUserBudget() async {
    int? userId = await _getUserId();
    final response = await http.get(
        Uri.parse('$baseUrl/api/Budgets/user/$userId'),
        headers: await _getHeaders());
    if (response.statusCode == 200) {

      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => BudgetModel.fromJson(json)).toList();
    } else if (response.statusCode == 403) {
      throw Exception('Unauthorized');
    }
    else {
      throw Exception('Failed to load budget');
    }
  }

  Future<BudgetModel> getBudgetById(int id) async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/Budgets/$id'),
        headers: await _getHeaders());
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return BudgetModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load budget');
    }
  }

  Future<void> createBudget(BudgetModel budget) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Budgets'),
      headers: await _getHeaders(),
      body: jsonEncode(budget.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create budget');
    }
  }

  Future<void> updateBudget(int id, BudgetModel budget) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/Budgets/$id'),
      headers: await _getHeaders(),
      body: jsonEncode(budget.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update budget');
    }
  }

  Future<void> deleteBudget(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/Budgets/$id'), headers: await _getHeaders());
    if (response.statusCode != 200) {
      throw Exception('Failed to delete budget');
    }
  }
}
