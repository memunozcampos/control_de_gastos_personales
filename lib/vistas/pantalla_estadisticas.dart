import 'package:flutter/material.dart';

class PantallaEstadisticas extends StatelessWidget {
  final double gastosTotales;
  final double gastosMesActualTotal;
  final double gastoPromedioPorDia;

  const PantallaEstadisticas({
    super.key,
    required this.gastosTotales,
    required this.gastosMesActualTotal,
    required this.gastoPromedioPorDia,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas Detalladas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    _buildTableRow(
                      context: context,
                      label: 'Total del Mes Actual',
                      value: gastosMesActualTotal,
                    ),
                    _buildTableRow(
                      context: context,
                      label: 'Promedio Diario',
                      value: gastoPromedioPorDia,
                    ),
                    _buildTableRow(
                      context: context,
                      label: 'Total Histórico',
                      value: gastosTotales,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Aquí puedes agregar gráficos o más estadísticas
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow({
    required BuildContext context,
    required String label,
    required double value,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(label, style: textTheme.bodyLarge),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '\$${value.toStringAsFixed(2)}',
            style: textTheme.bodyLarge?.copyWith(
              fontFeatures: [const FontFeature.tabularFigures()],
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
