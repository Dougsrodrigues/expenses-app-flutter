import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final ThemeData tema = ThemeData();

    return MaterialApp(
      home: Home(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        textTheme: tema.textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            button: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Transaction> _transactions = [
    Transaction(
      id: 't0',
      title: 'Roupas',
      value: 1000.76,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: 't1',
      title: 'Novo Tênis de Corrida',
      value: 310.76,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
    Transaction(
      id: 't2',
      title: 'Novo Tênis de Sair',
      value: 166.76,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: 't3',
      title: 'Roupas',
      value: 500.76,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: 't4',
      title: 'Roupas',
      value: 120.76,
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
  ];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((transaction) {
      return transaction.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: DateTime.now().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  Widget _getIconButton(IconData icon, Function() onPressed) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: onPressed,
            child: Icon(icon),
          )
        : IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
          );
  }

  @override
  Widget build(BuildContext context) {
    final isIos = Platform.isIOS;
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final iconList = isIos ? CupertinoIcons.refresh : Icons.list;
    final iconChart = isIos ? CupertinoIcons.refresh : Icons.pie_chart;

    final actions = [
      _getIconButton(
        isIos ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModal(context),
      ),
      if (isLandscape)
        _getIconButton(
          _showChart ? iconList : iconChart,
          () => {
            setState(() {
              _showChart = !_showChart;
            })
          },
        )
    ];

    final appBarAndroid = AppBar(
      title: Text(
        'Despesas pessoais',
      ),
      actions: actions,
    );

    final appBarIos = CupertinoNavigationBar(
      middle: Text('Despesas Pessoais'),
      trailing: Row(
        children: actions,
        mainAxisSize: MainAxisSize.min,
      ),
    );

    final appBarHeight = isIos
        ? appBarAndroid.preferredSize.height
        : appBarIos.preferredSize.height;

    final availableHeight =
        mediaQuery.size.height - appBarHeight - mediaQuery.padding.top;

    final body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showChart || !isLandscape)
              SizedBox(
                height:
                    isLandscape ? availableHeight * 0.6 : availableHeight * 0.3,
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !isLandscape)
              SizedBox(
                height: availableHeight * 0.7,
                child: TransactionList(_transactions, _removeTransaction),
              )
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: appBarIos,
          )
        : Scaffold(appBar: appBarAndroid, body: body);
  }
}
