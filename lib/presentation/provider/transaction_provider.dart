import 'package:flutter/material.dart';
import 'package:budgeting_flutter_app_v1/data/models/transaction_model.dart';
import 'package:budgeting_flutter_app_v1/data/repositories/transaction_repository.dart';
import 'package:budgeting_flutter_app_v1/data/repositories/wallet_repository.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _transactionRepository = TransactionRepository();
  final WalletRepository _walletRepository = WalletRepository();

  late List<TransactionModel> _transactions;
  late DateTime _selectedDate;
  double _userExpense = 0; // Initialize with default value
  double _userIncome = 0; // Initialize with default value
  double _userBalance = 0;

  List<TransactionModel> get transactions => _transactions;
  DateTime get selectedDate => _selectedDate;
  double get userExpense => _userExpense;
  double get userIncome => _userIncome;
  double get userBalance => _userBalance;

  TransactionProvider() {
    _transactions = [];
    _selectedDate = DateTime.now();
    fetchTransactions();
    getUserBalance(); // Memanggil getUserBalance() untuk menginisialisasi _userBalance
  }


  // Metode untuk mengambil saldo pengguna
  Future<double> getUserBalance() async {
    try {
      return await _walletRepository.getUserBalance();
    } catch (e) {
      print('Error fetching balance: $e');
      return 0; // Return default value if error occurs
    }
  }

  Future<void> fetchTransactions() async {
    try {
      _userExpense = await getUserExpense();
      _userIncome = await getUserIncome();
      _userBalance = await getUserBalance(); // Update userBalance
      _transactions = await _transactionRepository.getAllTransactions();
      notifyListeners();
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  // Metode lainnya...

  Future<double> getUserExpense() async {
    double totalExpense = 0;
    try {
      final List<TransactionModel> transactions = await _transactionRepository.getAllTransactions();
      totalExpense = transactions.where((transaction) => transaction.transactionType == 1).fold(0, (prev, transaction) => prev + transaction.amount!);
    } catch (e) {
      print('Error calculating user expense: $e');
    }
    return totalExpense;
  }

  Future<double> getUserIncome() async {
    double totalIncome = 0;
    try {
      final List<TransactionModel> transactions = await _transactionRepository.getAllTransactions();
      // Hitung total pemasukan berdasarkan transaksi dengan tipe 2 (pemasukan)
      totalIncome = transactions.where((transaction) => transaction.transactionType == 2).fold(0, (prev, transaction) => prev + transaction.amount!);
    } catch (e) {
      print('Error calculating user income: $e');
    }
    return totalIncome;
  }

  Future<void> updateTransaction(int id, TransactionModel updatedTransaction) async {
    try {
      await _transactionRepository.updateTransaction(id, updatedTransaction);
      await fetchTransactions();
    } catch (e) {
      print('Error updating transaction: $e');
    }
  }

  Future<void> addTransaction(TransactionModel newTransaction) async {
    try {
      await _transactionRepository.addTransaction(newTransaction);
      await fetchTransactions();
    } catch (e) {
      print('Error adding transaction: $e');
    }
  }

  Future<void> deleteTransaction(int transactionId) async {
    try {
      await _transactionRepository.deleteTransaction(transactionId);
      await fetchTransactions();
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }

  void clear() {
    _transactions.clear(); // Menghapus semua transaksi
    _selectedDate = DateTime.now(); // Mengatur tanggal terpilih ke tanggal sekarang
    notifyListeners(); // Memberi tahu listener bahwa ada perubahan
  }

  void setSelectedDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }
}
