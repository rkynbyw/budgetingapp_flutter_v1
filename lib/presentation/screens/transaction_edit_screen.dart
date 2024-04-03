import 'package:flutter/material.dart';
import 'package:budgeting_flutter_app_v1/data/models/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/transaction_provider.dart';

class TransactionEditScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const TransactionEditScreen({Key? key, this.transaction}) : super(key: key);

  @override
  _TransactionEditScreenState createState() => _TransactionEditScreenState();
}

class _TransactionEditScreenState extends State<TransactionEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  int _transactionType = 1; // Default transaction type
  int _transactionCategory = 1; // Default transaction category
  DateTime _selectedDate = DateTime.now();
  String _description = '';
  int _walletId = 59;
  int _userId = 15;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _transactionCategory = widget.transaction?.transactionCategoryID ?? 1;
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
      appBar: AppBar(
        title: Text('Edit Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: _transactionType.toString(),
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
              SizedBox(height: 16),
              TextFormField(
                initialValue: _transactionCategory.toString(),
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
              SizedBox(height: 16),
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          // Tampilkan hanya tanggal
                          _selectedDate == null ? 'No date selected' : DateFormat('dd MMM yyyy').format(_selectedDate),
                        ),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final amount = double.parse(_amountController.text);
                      final updatedTransaction = TransactionModel(
                        transactionType: _transactionType,
                        transactionCategoryID: _transactionCategory,
                        amount: amount,
                        date: _selectedDate,
                        description: _description,
                      );
                      _handleEditTransaction(context, widget.transaction!);
                    }
                  },
                  child: Text(widget.transaction != null ? 'Edit Transaction' : 'Add Transaction'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleEditTransaction(BuildContext context, TransactionModel transaction) {
    final updatedTransaction = TransactionModel(
      transactionID: transaction.transactionID,
      transactionCategoryID: _transactionCategory,
      amount: double.parse(_amountController.text),
      date: _selectedDate,
      description: _description,
      walletID: _walletId,
      userID: _userId,
    );

    Provider.of<TransactionProvider>(context, listen: false).updateTransaction(transaction.transactionID!, updatedTransaction);

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
        // Set hanya tanggal tanpa waktu
        _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      });
    }
  }
}
