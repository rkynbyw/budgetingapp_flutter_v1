import 'package:budgeting_flutter_app_v1/presentation/screens/budget_list_screen.dart';
import 'package:budgeting_flutter_app_v1/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/budget_model.dart';
import '../helper.dart';
import '../provider/budget_provider.dart';

class BudgetAddScreen extends StatefulWidget {
  @override
  _BudgetAddScreenState createState() => _BudgetAddScreenState();
}

class _BudgetAddScreenState extends State<BudgetAddScreen> {
  late DateTime _selectedMonth;
  final TextEditingController _amountController = TextEditingController();
  int _selectedCategory = 1;

  int _userId = 0;

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
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _initUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Selected Month: ${DateFormat('MMM yyyy').format(_selectedMonth)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),


            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _selectMonth(context);
              },
              child: Text('Select Month'),
            ),
            SizedBox(height: 24),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Amount',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: OutlineInputBorder()
              ),
              validator: (value) {
                return null;
              },
            ),
            SizedBox(height: 24),
            DropdownButtonFormField<int>(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              items: _buildCategoryDropdownItems(),
              decoration: InputDecoration(
                  labelText: 'Category',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: OutlineInputBorder()
              ),
              validator: (value) {
                return null;
              },
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _addBudget(context);
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
                          'Add Budget',
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

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialEntryMode: DatePickerEntryMode.input,
    );
    if (picked != null && picked != _selectedMonth) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month, 1);
      });
    }
  }

  List<DropdownMenuItem<int>> _buildCategoryDropdownItems() {
    return categoryMap.entries
        .where((entry) => entry.key <= 6)
        .map((entry) {
      return DropdownMenuItem<int>(
        value: entry.key,
        child: Text(entry.value),
      );
    }).toList();
  }

  void _addBudget(BuildContext context) {
    // Validate form
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter amount')),
      );
      return;
    }

    // Get amount from text controller
    double amount = double.parse(_amountController.text);

    // Create new BudgetModel instance
    BudgetModel newBudget = BudgetModel(
      monthDate: _selectedMonth,
      amount: amount,
      transactionCategoryID: _selectedCategory,
      userID: _userId,
    );

    print('New Budget: $newBudget');

    Provider.of<BudgetProvider>(context, listen: false).addBudget(newBudget);
    Provider.of<BudgetProvider>(context, listen: false).fetchBudgets();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Budget added successfully')),
    );

    _amountController.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(initialIndex: 1)),
          (route) => false,
    );

  }
}
