import 'package:flutter/material.dart';
import '../modelos/gastos.dart';
import '../vistas/pantalla_estadisticas.dart';

class ResumenDeGastos extends StatelessWidget {
  final List<Gasto> gastos;
  final mesActual = DateTime.now().month;
  final diasDelMesActual = DateTime.now().day;

  ResumenDeGastos({super.key, required this.gastos});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final double gastosTotales = gastos.fold(
      0.0,
      (sum, gasto) => sum + gasto.monto,
    );
    final gastosMesActual =
        gastos.where((gasto) => gasto.fecha.month == mesActual).toList();
    final double gastosMesActualTotal = gastosMesActual.fold(
      0.0,
      (sum, gasto) => sum + gasto.monto,
    );
    final double gastoPromedioPorDia =
        diasDelMesActual > 0 ? gastosMesActualTotal / diasDelMesActual : 0.0;

    return InkWell(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PantallaEstadisticas(
                    gastosTotales: gastosTotales,
                    gastosMesActualTotal: gastosMesActualTotal,
                    gastoPromedioPorDia: gastoPromedioPorDia,
                  ),
            ),
          ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(
                Theme.of(context).brightness == Brightness.light ? 0x1F : 0x3D,
              ),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Table(
          columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Resumen',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(),
              ],
            ),
            _buildTableRow(
              context: context,
              label: 'Total del Mes',
              value: gastosMesActualTotal,
            ),
            _buildTableRow(
              context: context,
              label: 'Promedio Diario',
              value: gastoPromedioPorDia,
            ),
            _buildTableRow(
              context: context,
              label: 'Total General',
              value: gastosTotales,
            ),
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
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '\$${value.toStringAsFixed(2)}',
            style: textTheme.bodyMedium?.copyWith(
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
