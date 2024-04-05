import 'package:flutter/material.dart';
import 'package:budgeting_flutter_app_v1/data/models/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/transaction_provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/wallet_provider.dart';

import '../helper.dart';

class TransactionEditScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const TransactionEditScreen({Key? key, this.transaction}) : super(key: key);

  @override
  _TransactionEditScreenState createState() => _TransactionEditScreenState();
}

class _TransactionEditScreenState extends State<TransactionEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  int _transactionType = 1;
  int _transactionCategory = 1;
  DateTime _selectedDate = DateTime.now();
  String _description = '';
  int _walletId = 59;
  int _userId = 15;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      // _transactionType = widget.transaction!.transactionType;
      _transactionCategory = widget.transaction!.transactionCategoryID ?? 1;
      _amountController.text = widget.transaction!.amount.toString();
      _selectedDate = widget.transaction!.date!;
      _description = widget.transaction!.description!;
      _walletId = widget.transaction!.walletID!;
      _userId = widget.transaction!.userID!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
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
                  decoration: const InputDecoration(
                      labelText: 'Transaction Type',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      border: OutlineInputBorder()),
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
                      border: OutlineInputBorder()),
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
                        decoration: const InputDecoration(
                            prefixText: '\Rp ',
                            labelText: 'Amount',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: Icon(Icons.calendar_today,
                            color: Colors.deepPurpleAccent,),
                          ),
                          Text(
                            _selectedDate == null
                                ? 'No date selected'
                                : DateFormat('dd MMM yyyy')
                                    .format(_selectedDate),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
                SizedBox(height: 24),
                DropdownButtonFormField<int>(
                  value: _walletId,
                  onChanged: (value) {
                    setState(() {
                      _walletId = value!;
                    });
                  },
                  items: Provider.of<WalletProvider>(context)
                      .wallets
                      .map((wallet) {
                    return DropdownMenuItem<int>(
                      value: wallet.walletId,
                      child: Text(wallet.walletName),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                      labelText: 'Wallet',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a wallet';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      border: OutlineInputBorder()),
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            final amount = double.parse(_amountController.text);
                            final updatedTransaction = TransactionModel(
                              transactionID: widget.transaction?.transactionID,
                              transactionType: _transactionType,
                              transactionCategoryID: _transactionCategory,
                              amount: amount,
                              date: _selectedDate,
                              description: _description,
                              walletID: _walletId,
                              userID: _userId,
                            );
                            _handleEditTransaction(context, updatedTransaction);
                          }
                        },
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
                                widget.transaction != null
                                    ? 'Edit Transaction'
                                    : 'Add Transaction',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ))))
              ]),
        ),
      ),
    );
  }

  void _handleEditTransaction(
      BuildContext context, TransactionModel updatedTransaction) {
    Provider.of<TransactionProvider>(context, listen: false).updateTransaction(
        updatedTransaction.transactionID!, updatedTransaction);
    Navigator.pop(context);
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
        _selectedDate =
            DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      });
    }
  }
}
