import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;
  //na hora de submeter o formulario, sera chamado esta funçao:
  TransactionForm(this.onSubmit);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();

//replicando o codigo dentro de onpressed aqui, para nao forçar o usuario a clicar em 'nova transaçao', mas submeter a nova conta quando clicar no botao de submeter do teclado virtual:
  _submitForm() {
    final title = _titleController.text;
    //se nao converter, gera o valor 0:
    final value = double.tryParse(_valueController.text) ?? 0.0;
//evitar que chame 'onsubmit' se o valor for invalido:
    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }
    widget.onSubmit(title, value, _selectedDate!);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
                controller: _titleController,
                onSubmitted: (_) =>
                    _submitForm(), //para fechar o teclado e submeter (se o valor for válido)
                decoration: InputDecoration(labelText: 'Título')),
            TextField(
              controller: _valueController,
              //inserindo teclado numerico e decimal:
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              //sempre que houver submissao no teclado virtual, sera chamado:
              onSubmitted: (_) =>
                  _submitForm(), //qd precisa receber um parametro que nao vai usar, coloca-se '_'
              decoration: InputDecoration(
                labelText: 'Valor (R\$)',
              ),
            ),
            Container(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    //expanded vai empurrar o botao,para ocupar toda a linha
                    child: Text(
                      _selectedDate == null
                          ? 'Nenhuma data selecionada!'
                          : "Data selecionada: ${DateFormat('dd/MM/y').format(_selectedDate!)}",
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Selecionar data',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _showDatePicker,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  child: Text('Nova transação'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green, onPrimary: Colors.white),
                  onPressed: _submitForm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
