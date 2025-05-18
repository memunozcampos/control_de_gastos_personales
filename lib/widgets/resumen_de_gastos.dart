import 'package:flutter/material.dart';
import '../modelos/gastos.dart';
import '../utilidades/funciones_utiles.dart'
    show acumuladorGastos, formatearValorMonetario;
import '../vistas/vista_estadisticas.dart';

class ResumenDeGastos extends StatelessWidget {
  final List<Gasto> gastos;
  final mesActual = DateTime.now().month;
  final diasDelMesActual = DateTime.now().day;

  ResumenDeGastos({super.key, required this.gastos});

  @override
  Widget build(BuildContext context) {
    final esquemaColores = Theme.of(context).colorScheme;
    final esquemaTexto = Theme.of(context).textTheme;

    final double gastosTotales = gastos.fold(0.0, acumuladorGastos);
    final gastosMesActual =
        gastos.where((gasto) => gasto.fecha.month == mesActual).toList();
    final double gastosMesActualTotal = gastosMesActual.fold(
      0.0,
      acumuladorGastos,
    );
    final double gastoPromedioPorDia =
        diasDelMesActual > 0 ? gastosMesActualTotal / diasDelMesActual : 0.0;

    return InkWell(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VistaEstadisticas(gastos: gastos),
            ),
          ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: esquemaColores.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: esquemaColores.shadow.withAlpha(
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
                    style: esquemaTexto.headlineSmall?.copyWith(
                      color: esquemaColores.primary,
                    ),
                  ),
                ),
                const SizedBox(),
              ],
            ),
            _construirFila(
              context: context,
              datoResumen: 'Total del Mes',
              valor: gastosMesActualTotal,
            ),
            _construirFila(
              context: context,
              datoResumen: 'Promedio Diario (en $diasDelMesActual días)',
              valor: gastoPromedioPorDia,
            ),
            _construirFila(
              context: context,
              datoResumen: 'Total General',
              valor: gastosTotales,
            ),
          ],
        ),
      ),
    );
  }

  TableRow _construirFila({
    required BuildContext context,
    required String datoResumen,
    required double valor,
  }) {
    final esquemaTexto = Theme.of(context).textTheme;

    return TableRow(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            datoResumen,
            style: esquemaTexto.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            formatearValorMonetario(valor),
            style: esquemaTexto.bodyMedium?.copyWith(
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
