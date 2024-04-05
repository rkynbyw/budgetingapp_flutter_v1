import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/budget_provider.dart';
import 'package:budgeting_flutter_app_v1/data/models/budget_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper.dart';

class BudgetEditScreen extends StatefulWidget {
  final BudgetModel budget;

  const BudgetEditScreen({Key? key, required this.budget}) : super(key: key);

  @override
  _BudgetEditScreenState createState() => _BudgetEditScreenState();
}

class _BudgetEditScreenState extends State<BudgetEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _selectedCategory = 1;
  int? _userId = 0;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.budget.amount.toString();
    _selectedDate = widget.budget.monthDate!;
    _selectedCategory = widget.budget.transactionCategoryID ?? 1;
    _initUserId();

  }

  @override
  void _initUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField<int>(
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                items: categoryMap.entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                decoration: InputDecoration(
                    labelText: 'Category',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    border: OutlineInputBorder()
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: Icon(Icons.calendar_today
                          ,color: Colors.deepPurpleAccent,),
                        ),
                        Text(
                          // Tampilkan hanya tanggal
                          _selectedDate == null ? 'No date selected' : DateFormat('dd MMM yyyy').format(_selectedDate),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(width: 64),
                ],
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final double amount = double.parse(_amountController.text);
                      final updatedBudget = BudgetModel(
                        budgetID: widget.budget.budgetID,
                        monthDate: _selectedDate,
                        amount: amount,
                        transactionCategoryID: _selectedCategory,
                        userID: _userId
                      );
                      _handleEditBudget(context, updatedBudget);
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
                            'Edit Budget',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                    )
                  // child: Text('Save Budget'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleEditBudget(BuildContext context, BudgetModel updatedBudget) {
    Provider.of<BudgetProvider>(context, listen: false).updateBudget(updatedBudget.budgetID!, updatedBudget);
    Provider.of<BudgetProvider>(context, listen: false).fetchBudgets();
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
        _selectedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      });
    }
  }
}
