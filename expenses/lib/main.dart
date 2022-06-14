import 'package:expenses/components/transaction_form.dart';
import 'components/chart.dart';
import 'package:flutter/material.dart';
import './components/transaction_list.dart';
import './components/transaction_form.dart';
import 'models/transaction.dart';
import 'dart:math';
import 'package:flutter_localizations/flutter_localizations.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      home: MyHomePage(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.green,
          secondary: Colors.amber,
        ),
        textTheme: tema.textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    // Transaction(
    //     id: 't1',
    //     title: 'Internet',
    //     value: 119.90,
    //     date: DateTime.now().subtract(Duration(days: 6))),
    // Transaction(
    //     id: 't2',
    //     title: 'Conta de luz',
    //     value: 211.35,
    //     date: DateTime.now().subtract(Duration(days: 5))),
    // Transaction(
    //     id: 't3',
    //     title: 'Academia',
    //     value: 100.00,
    //     date: DateTime.now().subtract(Duration(days: 4))),
    // Transaction(
    //     id: 't4',
    //     title: 'Mercado',
    //     value: 151.15,
    //     date: DateTime.now().subtract(Duration(days: 3))),
    // Transaction(
    //     id: 't5',
    //     title: 'Celular',
    //     value: 20.00,
    //     date: DateTime.now().subtract(Duration(days: 2))),
  ];
//criando o geter para passar as transacoes recentes p/ o componente de soma/porcentagem:

  List<Transaction> get _recentTransactions {
    //método para filtrar as transacoes recentes:
    //retorna true/fase, se a data for depois/after da data subtraida sera true
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title:
          title, //nao confundir, pois o primeiro title é o atributo da funcao, e o segundo é o parametro
      value: value,
      date: date,
    );
    setState(() {
      //necessario ja que esta dentro de um componente Stateful, pois qd o estado muda, automaticamente a arvore de componentes tb atualiza
      _transactions.add(newTransaction);
    });
    //fechando o modal apos o preenchimento:
    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
      //filtro para remover um elemento da lista; ao retornar true o elemento é filtrado e removido
      //sempre que o id passado como parametro for igual ao da transacao selecionada, sera removido
      //essa funcao sera passada dentro do botao/iconeDel criado no arquivo transaction_list, na parte do 'onpressed',
      //sera passada como parametro da funcao TransactionList mais abaixo
      //tb foi necessario adicionar o costrutor onRemove, na classe TransactionList
    });
  }

//exibindo o formulario associado aos 2 botoes que vao abrir o modal para ter acesso aos textfield e adicionar nova transaçao:
  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Despesa semanal"),
          //adicionando botão para adicionar transacao:
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _openTransactionFormModal(context),
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          //diferente do 'center", 'Colunm" recebe um conjunto de elementos

          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // children é uma lista
            Chart(_recentTransactions),
            TransactionsList(_transactions, _deleteTransaction),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      //centralizando o botao de baixo:
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

//inserido mainAxisAligment (eixo horizontal) e crossAxis..(vertical)
