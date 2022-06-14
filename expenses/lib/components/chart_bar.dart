import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double value;
  final double percentage;

  ChartBar({
    required this.label,
    required this.value,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //envolvendo o texto com o widget Fitted para o valor absoluto nao alterar o tamanho da barra:
        FittedBox(
            child: Text('${(percentage * 100).toStringAsFixed(1)}' + '%')),

        SizedBox(height: 5),
        Container(
          height: 60,
          width: 10,
          //gerando a barra do grafico; stack permite colocar um componente em cima do outro
          child: Stack(
            alignment:
                Alignment.bottomCenter, //para colorir(barra) de baixo pra cima
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  color: Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              // o 'FractionallySizedBox' que será o tamanho da barra de acordo com a porcentagem
              FractionallySizedBox(
                heightFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}
