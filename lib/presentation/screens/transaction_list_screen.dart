import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgeting_flutter_app_v1/presentation/provider/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:budgeting_flutter_app_v1/presentation/screens/transaction_edit_screen.dart';
import 'package:budgeting_flutter_app_v1/presentation/screens/transaction_form_screen.dart';

class TransactionListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Consumer<TransactionProvider>(
                      builder: (context, transactionProvider, _) {
                        final double income = transactionProvider.userIncome;

                        return _buildInfoCard(Icons.arrow_upward, 'Pemasukan', income);
                      },
                    ),
                  ),

                  Expanded(
                    child: Consumer<TransactionProvider>(
                      builder: (context, transactionProvider, _) {
                        final double expense = transactionProvider.userExpense;
                        return _buildInfoCard(Icons.arrow_downward, 'Pengeluaran', expense);
                      },
                    ),
                  ),

                  Expanded(
                    child: Consumer<TransactionProvider>(
                        builder: (context, transactionProvider, _) {
                          final double balance = transactionProvider.userBalance;
                          return _buildInfoCard(Icons.account_balance_wallet, 'Saldo', balance);
                        }
                    )

                  ),
                ],
              ),
            ),
            Text('List Transactions'),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<TransactionProvider>(
                builder: (context, transactionProvider, _) {
                  if (transactionProvider.transactions.isEmpty) {
                    return Center(child: Text('No transactions yet'));
                  } else {
                    final transactions = transactionProvider.transactions;
                    return Column(
                      children: transactions.map((transaction) {
                        return Column(
                          children: [
                            Dismissible(
                              key: Key(transaction.transactionID.toString()),
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
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm"),
                                      content: Text("Are you sure you want to delete this transaction?"),
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
                              },
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart) {
                                  transactionProvider.deleteTransaction(transaction.transactionID!);
                                }
                              },
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TransactionEditScreen(transaction: transaction),
                                    ),
                                  );
                                },
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  child: Icon(Icons.category, color: Colors.white),
                                ),
                                title: Text(
                                  'Category: ${transaction.transactionCategoryID}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${DateFormat('dd MMM yyyy').format(transaction.date!)}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                trailing: Text(
                                  '${transaction.transactionType == 1 ? '-' : '+'}${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(transaction.amount)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: transaction.transactionType == 1 ? Colors.red : Colors.green,
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
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TransactionFormScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildInfoCard(IconData icon, String title, double value) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final formattedValue = formatter.format(value);

    return Card(
      color: Colors.deepPurpleAccent,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(icon, color: Colors.deepPurpleAccent),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              formattedValue,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
