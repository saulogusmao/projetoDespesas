import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;

  TransactionsList(this.transactions, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      //operação ternaria: se não houver transações ira chamar a imagem(dentro da coluna), se nao, ira chamar a funcao da lista(listview):

      child: transactions.isEmpty
          ? Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'Nenhuma transação cadastrada!',
//pegando o tema da aplicação:
                  style: Theme.of(context).textTheme.headline6,
                ),
                //SizedBox faz o espaçamento entre as linhas
                SizedBox(height: 20),
                //envolvendo a imagem num container para ela caber na tela sem gerar overflow:
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              //substituindo o SingleChildScrollView por ListView
              //como listview nao tem limites e consome mt memoria, foi usado listview.builder e itemcount para otimizar o scroll em relaçao ao tamanho exato da lista
              itemCount: transactions.length,
              itemBuilder: (ctx, index) {
                //assim será renderizado somente o que couber na tela, economizando memoria e melhorando o desempenho
                final tr = transactions[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      radius: 30,
                      child: Padding(
                        //padding faz espaçamento da margem, dentro do icone/caixa
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          //fittedbox ajusta o texto
                          child: Text(
                            'R\$${tr.value}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      tr.title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat('d MMM y').format(tr.date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () => onRemove(tr.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
