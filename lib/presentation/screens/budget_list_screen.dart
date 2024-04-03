import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/budget_provider.dart';
import 'package:budgeting_flutter_app_v1/data/models/budget_model.dart';
import 'package:intl/intl.dart';

class BudgetListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Budget List'),
      //   // backgroundColor: Colors.orangeAccent,
      // ),
      body: Padding(
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
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Icon(Icons.account_balance_wallet, color: Colors.white),
                          ),
                          title: Text('Category: ${budget.transactionCategoryID}'),
                          subtitle: Text(
                              'Amount: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(budget.amount)}'),
                          trailing: Text('Month: ${DateFormat('MMM yyyy').format(budget.monthDate!)}'),
                          onTap: () {
                            // Implement onTap action here
                          },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement onPressed action here
        },
        // backgroundColor: Colors.orangeAccent,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
