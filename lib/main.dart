// import 'package:flutter/services.dart';
import './widgets/new_transaction.dart';
import 'package:flutter/material.dart';

import 'models/transaction.dart';
import 'widgets/chart.dart';
import 'widgets/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monthly Expenses',
      home: MyHomePage(),
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          errorColor: Colors.red,
          fontFamily: 'QuickSand',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 20)))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  bool _showchart = false;
  final List<Transaction> transactions = [];
  List<Transaction> get recenttransactions {
    return transactions.where(
      (tx) {
        return tx.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  void _addNewTransaction(
      String txtitle, double txamount, DateTime pickeddate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txtitle,
        amount: txamount,
        date: pickeddate);

    setState(() {
      transactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((tx) => tx.id == id);
    });
  }

  String titleInput;

  String amountInput;

  List<Widget> _buildLandScapeContent(
      MediaQueryData mediaquerry, AppBar appbar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch(
              value: _showchart,
              onChanged: (val) {
                setState(() {
                  _showchart = val;
                });
              })
        ],
      ),
      _showchart
          ? Container(
              height: (mediaquerry.size.height -
                      appbar.preferredSize.height -
                      mediaquerry.padding.top) *
                  0.7,
              child: Chart(recenttransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPotraitContent(
      MediaQueryData mediaquerry, AppBar appbar, Widget txListWidget) {
    return [
      Container(
          height: (mediaquerry.size.height -
                  appbar.preferredSize.height -
                  mediaquerry.padding.top) *
              0.3,
          child: Chart(recenttransactions)),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaquerry = MediaQuery.of(context);
    final islandscape = mediaquerry.orientation == Orientation.landscape;
    final appbar = AppBar(
      title: Text('Monthly Expenses'),
      actions: [
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context))
      ],
    );
    final txListWidget = Container(
        height: (mediaquerry.size.height -
                appbar.preferredSize.height -
                mediaquerry.padding.top) *
            0.7,
        child: TransactionList(transactions, _deleteTransaction));
    return Scaffold(
      appBar: appbar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (islandscape)
              ..._buildLandScapeContent(mediaquerry, appbar, txListWidget),
            if (!islandscape)
              ..._buildPotraitContent(mediaquerry, appbar, txListWidget),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
