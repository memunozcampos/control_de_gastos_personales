// Aquí irá el resumen de gastos, que mostrará el total de gastos.
//Se puede mostrar un gráfico de barras o un gráfico circular. por categoría o por mes.

import 'package:flutter/material.dart';

class ResumenDeGastos extends StatelessWidget {
  final double totalGastos;

  const ResumenDeGastos({super.key, required this.totalGastos});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Resumen', style: Theme.of(context).textTheme.headlineMedium),
        Text(
          'Total Gastos: \$${totalGastos.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        // Aquí puedes agregar un gráfico o una lista de gastos
      ],
    );
  }
}
