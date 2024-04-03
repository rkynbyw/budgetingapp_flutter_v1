import 'package:budgeting_flutter_app_v1/data/datasources/budget_datasource.dart';
import 'package:budgeting_flutter_app_v1/data/models/budget_model.dart';

class BudgetRepository {
  final BudgetDataSource _dataSource = BudgetDataSource();

  Future<List<BudgetModel>> getUserBudgets() async {
    try {
      return await _dataSource.getUserBudget();
    } catch (e) {
      throw Exception('Failed to get budget by id: $e');
    }
  }

  Future<BudgetModel> getBudgetById(int id) async {
    try {
      return await _dataSource.getBudgetById(id);
    } catch (e) {
      throw Exception('Failed to get budget by id: $e');
    }
  }

  Future<void> createBudget(BudgetModel budget) async {
    try {
      await _dataSource.createBudget(budget);
    } catch (e) {
      throw Exception('Failed to create budget: $e');
    }
  }

  Future<void> updateBudget(int id, BudgetModel budget) async {
    try {
      await _dataSource.updateBudget(id, budget);
    } catch (e) {
      throw Exception('Failed to update budget: $e');
    }
  }

  Future<void> deleteBudget(int id) async {
    try {
      await _dataSource.deleteBudget(id);
    } catch (e) {
      throw Exception('Failed to delete budget: $e');
    }
  }
}
