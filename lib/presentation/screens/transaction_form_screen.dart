import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/screens/home_screen.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/transaction_provider.dart';
import 'package:budgeting_flutter_app_v1/data/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionFormScreen extends StatelessWidget {
  const TransactionFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TransactionForm(),
      ),
    );
  }
}

class TransactionForm extends StatefulWidget {
  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _walletController = TextEditingController();
  int _transactionType = 1; // Default transaction type
  int _transactionCategory = 1; // Default transaction category
  DateTime _selectedDate = DateTime.now();
  String _description = 'Description';
  int _walletId = 59; // Default wallet ID
  int _userId = 15; // Default user ID

  @override
  void initState() {
    super.initState();
    _initUserId();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _walletController.dispose();
    super.dispose();
  }

  void _initUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
    }
  }

  // Fungsi untuk menampilkan date picker
  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        // Set hanya tanggal tanpa waktu
        _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      });
    }
  }

  void _submitTransaction(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final amount = double.parse(_amountController.text);
      final transaction = TransactionModel(
          transactionCategoryID: _transactionCategory,
          amount: amount,
          date: _selectedDate,
          description: _description,
          walletID: _walletId,
          userID: _userId
      );
      Provider.of<TransactionProvider>(context, listen: false).addTransaction(transaction);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Transaction Type'),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter transaction type';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _transactionType = int.parse(value!);
                });
              },
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(labelText: 'Transaction Category'),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter transaction category';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _transactionCategory = int.parse(value!);
                });
              },
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(prefixText: '\Rp ', labelText: 'Amount'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        // Tampilkan hanya tanggal
                        _selectedDate == null ? 'No date selected' : _selectedDate.toLocal().toString().split(' ')[0],
                      ),
                      IconButton(
                        onPressed: _presentDatePicker,
                        icon: Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _walletController,
              decoration: InputDecoration(labelText: 'Wallet ID'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter wallet ID';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _walletId = int.parse(value!);
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  _description = value!;
                });
              },
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () => _submitTransaction(context),
                child: Text('Add Transaction'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
