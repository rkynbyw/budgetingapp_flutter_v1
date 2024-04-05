import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/screens/home_screen.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/transaction_provider.dart';
import 'package:budgeting_flutter_app_v1/data/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper.dart';
import '../provider/wallet_provider.dart';

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
  int _walletId = 0; // Default wallet ID
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


  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {

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
      print('New Transaction: $transaction');
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
            DropdownButtonFormField<int>(
              value: _transactionType,
              onChanged: (value) {
                setState(() {
                  _transactionType = value!;
                });
              },
              items: [
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('Pengeluaran'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('Pemasukan'),
                ),
              ],
              decoration: InputDecoration(
                  labelText: 'Transaction Type',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: OutlineInputBorder()

              ),
              validator: (value) {
                if (value == null) {
                  return 'Please select transaction type';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            DropdownButtonFormField<int>(
              value: _transactionCategory,
              onChanged: (value) {
                setState(() {
                  _transactionCategory = value!;
                });
              },
              items: categoryMap.entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              decoration: InputDecoration(
                  labelText: 'Transaction Category',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: OutlineInputBorder()
              ),
              validator: (value) {
                if (value == null) {
                  return 'Please select transaction category';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        prefixText: '\Rp ', labelText: 'Amount',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      return null;
                    },
                  ),
                ),
                // const SizedBox(width: 24),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _presentDatePicker,
                        icon: Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(

                        _selectedDate == null ? 'No date selected' : _selectedDate.toLocal().toString().split(' ')[0],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(width: 64),
              ],
            ),
            SizedBox(height: 24),
            DropdownButtonFormField<int>(
              value: _walletId == 0 ? null : _walletId,
              onChanged: (value) {
                setState(() {
                  _walletId = value!;
                });
              },
              items: [
                DropdownMenuItem<int>(
                  value: 0,
                  child: Text('<Pilih Wallet>'),
                ),
                ...Provider.of<WalletProvider>(context).wallets.map((wallet) {
                  return DropdownMenuItem<int>(
                    value: wallet.walletId,
                    child: Text(wallet.walletName),
                  );
                }).toList(),
              ],
              decoration: InputDecoration(
                labelText: 'Wallet',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: OutlineInputBorder()
                // contentPadding: EdgeInsets.symmetric(vertical: 16), // Atur jarak di sini
              ),
              style: TextStyle(fontSize: 16),
              validator: (value) {
                if (value == null || value == 0) {
                  return 'Please select a wallet';
                }
                return null;
              },
            ),


            SizedBox(height: 24),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Description',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: OutlineInputBorder()
              ),
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

                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.transparent),
                    padding:
                    MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF6D55BD),
                            Color(0xFFB700FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: 150,
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Add Transaction',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                  )

              ),
            ),
          ],
        ),
      ),
    );
  }
}
