import 'package:flutter/material.dart';
import 'package:budgeting_flutter_app_v1/data/models/budget_model.dart';
import 'package:budgeting_flutter_app_v1/data/repositories/budget_repository.dart';

import '../../data/repositories/transaction_repository.dart';

class BudgetProvider with ChangeNotifier {
  final BudgetRepository _budgetRepository = BudgetRepository();
  final TransactionRepository _transactionRepository = TransactionRepository();
  late List<BudgetModel> _budgets;

  List<BudgetModel> get budgets => _budgets;

  BudgetProvider() {
    _budgets = [];
    fetchBudgets();
  }

  void clear() {
    _budgets.clear();
    _errorMessage = '';
    notifyListeners();
  }

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  Future<void> fetchBudgets() async {
    try {
      _budgets = await _budgetRepository.getUserBudgets();
      for (var budget in _budgets) {
        double expense = await _transactionRepository.getExpenseForMonth(
          budget.monthDate!.year,
          budget.monthDate!.month,
          budget.transactionCategoryID!,
        );
        budget.expense = expense;
        budget.remainingAmount = (budget.amount ?? 0) - (expense ?? 0);
        // print(budget.expense);
        // print(budget.remainingAmount);

      }
      notifyListeners();
    } catch (e) {
      if (e.toString().contains('Unauthorized')) {
        _budgets.clear();
        notifyListeners();
        _errorMessage = 'Please upgrade your subscription to access budgeting feature';
        notifyListeners();
      } else {
        print('Error fetching budgets: $e');
      }
    }
  }

  Future<void> updateBudget(int id, BudgetModel updatedBudget) async {
    try {
      await _budgetRepository.updateBudget(id, updatedBudget);
      await fetchBudgets();
    } catch (e) {
      print('Error updating budget: $e');
    }
  }

  Future<void> addBudget(BudgetModel newBudget) async {
    try {
      await _budgetRepository.createBudget(newBudget);
      await fetchBudgets();
    } catch (e) {
      print('Error adding budget: $e');
    }
  }

  Future<void> deleteBudget(int budgetId) async {
    try {
      await _budgetRepository.deleteBudget(budgetId);
      await fetchBudgets();
    } catch (e) {
      print('Error deleting budget: $e');
    }
  }
}
