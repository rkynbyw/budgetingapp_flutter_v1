import 'package:budgeting_flutter_app_v1/presentation/screens/profile_screen.dart';
import 'package:budgeting_flutter_app_v1/presentation/screens/user_login_screens.dart';
import 'package:budgeting_flutter_app_v1/presentation/screens/wallet_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:budgeting_flutter_app_v1/presentation/screens/transaction_list_screen.dart';
import 'package:budgeting_flutter_app_v1/presentation/screens/budget_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/budget_provider.dart';
import '../provider/transaction_provider.dart';

class HomeScreen extends StatefulWidget {
  final int? initialIndex;

  HomeScreen({Key? key, this.initialIndex}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
    Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
    Provider.of<BudgetProvider>(context, listen: false).fetchBudgets();

    _selectedIndex = widget.initialIndex ?? 0;
  }

  static List<Widget> _widgetOptions = <Widget>[
    TransactionListScreen(),
    BudgetListScreen(),
    WalletListScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex != 3 ? AppBar(
        title: Text('Hello, $_username',
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.logout),
        //     onPressed: () async {
        //       showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return AlertDialog(
        //             title: Text('Logout'),
        //             content: Text('Are you sure you want to logout?'),
        //             actions: [
        //               TextButton(
        //                 onPressed: () => Navigator.pop(context),
        //                 child: Text('Cancel'),
        //               ),
        //               TextButton(
        //                 onPressed: () async {
        //                   SharedPreferences prefs = await SharedPreferences.getInstance();
        //                   await prefs.clear();
        //                   Provider.of<TransactionProvider>(context, listen: false).clear();
        //                   Provider.of<BudgetProvider>(context, listen: false).clear();
        //                   Navigator.pushReplacement(
        //                     context,
        //                     MaterialPageRoute(builder: (context) => LoginPage()),
        //                   );
        //                 },
        //                 child: Text('Logout'),
        //               ),
        //             ],
        //           );
        //         },
        //       );
        //     },
        //   ),
        // ],
      ) : null,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Budgets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );

  }
}
