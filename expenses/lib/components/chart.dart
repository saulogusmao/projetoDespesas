import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import 'chart_bar.dart';
import 'package:expenses/components/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction>
      recentTransaction; //para criar parametro ao manipular um 'value' dinamico
  Chart(
      this.recentTransaction); //para usar as novas transacoes em 'recenttransaction' e calcular o valor total de acordo com a data
  //criando a lista para entrar dentro do row
  //sera 'Object' pq o valor sera variado entre string e numerico (dentro de 'return day/value')

  List<Map<String, Object>> get groupedTransactions {
    //usando o metodo "generate" para criar a lista com 7 elementos, que sao os 7 dias da semana
    return List.generate(7, (index) {
      //manipulando 'index' para deixar o valor de 'day' dinamico tendo como referencia o dia de 'hoje', fazendo subtrações conforme o valor do indice correspondente ao dia
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      //pegando a primeira letra do dia da semana a partir do 'weekday': (foi comentado pq foi substituido na chave 'day')
//DateFormat.E().format(weekDay)[0] - o '[0]' corresponde à primeira letra

//fazendo a soma dos valores da semana a fim de gerar as porcentagens de gastos respectivo ao dia:

      double totalSum = 0.0;
      for (var i = 0; i < recentTransaction.length; i++) {
        //pra saber se a transacao mais recente corresponde à mesma semana em 'weekday':
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = recentTransaction[i].date.month == weekDay.month;
        bool sameYear = recentTransaction[i].date.year == weekDay.year;
//se for mesmo dia/mes/ano , o valor da transacao sera acrescentado na soma da semana:
        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransaction[i].value;
        }
      }

      return {
        'day': DateFormat('EEE', 'pt_BR').format(weekDay),
        'value': totalSum,
      };
    }).reversed.toList();
  }

  //ajustando o calculo para passar o percentual correto da semana
  double get _weekTotalValue {
    //metodo fold:  groupedTransactions.fold(initialValue, (previousValue, element) => null)
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + (tr['value'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    groupedTransactions;
    return Card(
      elevation: 6, //para destacar
      margin: EdgeInsets.all(20),
      child: Padding(
        //para dar espaçamento
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //para criar varios componentes lado a lado/horizontal
          children: groupedTransactions.map((tr) {
            //imprimindo a primeira letra do dia e valor da transação
            return Flexible(
              //para nao ficar desproporcional
              fit: FlexFit.tight,
              child: ChartBar(
                  label: tr['day'].toString(),
                  value: (tr['value'] as double),
                  percentage: _weekTotalValue == 0
                      ? 0
                      : (tr['value'] as double) / _weekTotalValue),
            );
          }).toList(),
        ),
      ),
    );
  }
}
