import 'package:budgeting_flutter_app_v1/data/datasources/transaction_datasource.dart';
import 'package:budgeting_flutter_app_v1/data/models/transaction_model.dart';

class TransactionRepository {
  final TransactionDataSource _dataSource = TransactionDataSource();

  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      return await _dataSource.getAllTransactions();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<TransactionModel> getTransactionById(int id) async {
    try {
      return await _dataSource.getTransactionById(id);
    } catch (e) {
      throw Exception('Failed to fetch transaction: $e');
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _dataSource.createTransaction(transaction);
    } catch (e) {
      throw Exception('Failed to add transaction (repository): $e');
    }
  }

  Future<void> updateTransaction(int id, TransactionModel transaction) async {
    try {
      await _dataSource.updateTransaction(id, transaction);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await _dataSource.deleteTransaction(id);
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  Future<double> getExpenseForMonth(
      int year, int month, int transactionCategoryId) async {
    try {
      return await _dataSource.getExpenseForMonth(
          year, month, transactionCategoryId);
    } catch (e) {
      throw Exception('Failed to get expense for month: $e');
    }
  }
}

