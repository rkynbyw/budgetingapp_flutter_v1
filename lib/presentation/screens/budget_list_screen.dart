import 'package:budgeting_flutter_app_v1/presentation/screens/budget_add_screen.dart';
import 'package:budgeting_flutter_app_v1/presentation/screens/budget_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/budget_provider.dart';
import 'package:budgeting_flutter_app_v1/data/models/budget_model.dart';
import 'package:intl/intl.dart';

import '../helper.dart';

class BudgetListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<BudgetProvider>(context, listen: false).fetchBudgets();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Budget List'),
      //   // backgroundColor: Colors.orangeAccent,
      // ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     'Your Budgets',
          //     style: TextStyle(
          //       fontSize: 20,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<BudgetProvider>(
                  builder: (context, budgetProvider, _) {
                    final budgets = budgetProvider.budgets;
                    if (budgetProvider.errorMessage.isNotEmpty) {
                      return Center(
                        child: Text(
                          budgetProvider.errorMessage,
                        ),
                      );
                    } else if (budgets.isEmpty) {
                      return Center(
                        child: Text('No budgets yet'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: budgets.length,
                        itemBuilder: (context, index) {
                          final budget = budgets[index];
                          var transaction;
                          String categoryName = categoryMap[budget.transactionCategoryID] ?? 'Unknown';
                          return Column(

                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Dismissible(
                                  key: Key(budget.budgetID.toString()),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  confirmDismiss: (direction) async {
                                    bool confirmDelete = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirm"),
                                          content: Text("Are you sure you want to delete this budget?"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(true),
                                              child: Text("Delete"),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    return confirmDelete;
                                  },
                                  onDismissed: (direction) {

                                    if (direction == DismissDirection.endToStart) {
                                      Provider.of<BudgetProvider>(context, listen: false).deleteBudget(budget.budgetID!);
                                      Provider.of<BudgetProvider>(context, listen: false).fetchBudgets();
                                    }
                                  },
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BudgetEditScreen(budget: budget),
                                        ),
                                      );
                                    },
                                    contentPadding:
                                    EdgeInsets.all(0),
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$categoryName',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${DateFormat('MMM yyyy').format(budget.monthDate!)}',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),

                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Amount: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(budget.amount)}',
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text('Expense:'),
                                                Text(
                                                  ' ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(budget.expense ?? 0)}',
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text('Remaining:'),
                                                Text(
                                                  '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(budget.remainingAmount ?? 0)}',
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        LinearProgressIndicator(
                                          value: budget.expense! / budget.amount!,
                                          backgroundColor: budget.expense! / budget.amount! > 1
                                              ? Colors.red
                                              : Colors.grey[300],
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.deepPurple,
                                          ),
                                        ),
                                        if (budget.expense! / budget.amount! > 1)
                                          Column(
                                            children: [
                                              SizedBox(height: 6,),
                                              Center(
                                                child: Text(
                                                  'Your expense out of budget',
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),

                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (budget.expense! / budget.amount! <= 1)
                                              Text(
                                                '${(budget.expense! / budget.amount! * 100).toStringAsFixed(2)}% ',
                                                style: TextStyle(fontSize: 12),
                                              ),

                                          ],
                                        ),
                                      ],
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.deepPurple,
                                      child: Icon(Icons.account_balance_wallet,
                                          color: Colors.white),
                                    ),

                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey[300],
                                thickness: 1,
                                indent: 16,
                                endIndent: 16,
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BudgetAddScreen()),
          );
        },
        backgroundColor: Colors.deepPurpleAccent,
        // backgroundColor: Colors.orangeAccent,
        child: Icon(Icons.add, color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
