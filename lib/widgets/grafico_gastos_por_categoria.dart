// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../utilidades/constantes.dart' show iconosCategorias;
import '../utilidades/funciones_utiles.dart'
    show formatearValorMonetario, formateadorMoneda;

class GraficoGastosPorCategoria extends StatelessWidget {
  final Map<String, double> gastosPorCategoria;

  const GraficoGastosPorCategoria({
    super.key,
    required this.gastosPorCategoria,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final List<BarChartGroupData> gruposBarras = [];
    final colorSobreSuperficie = tema.colorScheme.onSurface;
    final colorPrimario = tema.colorScheme.primary;
    final colorSecundario = tema.colorScheme.secondary;
    final esModoOscuro = tema.brightness == Brightness.dark;

    List<MapEntry<String, double>> categoriasOrdenadas =
        gastosPorCategoria.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value));

    double valorMaxY = 0;
    categoriasOrdenadas.forEach((entrada) {
      if (entrada.value > valorMaxY) valorMaxY = entrada.value;
    });
    valorMaxY = (valorMaxY * 1.25).ceilToDouble();

    int i = 0;
    for (var entrada in categoriasOrdenadas) {
      gruposBarras.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: entrada.value,
              color:
                  i % 2 == 0
                      ? colorPrimario
                      : colorSecundario.withAlpha((0.85 * 255).toInt()),
              width: 18,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
          ],
        ),
      );
      i++;
    }

    if (gruposBarras.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Gastos por Categoría",
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 280,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: valorMaxY,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      //tooltipBgColor: tema.cardColor.withAlpha((0.9*255).toInt()),
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      tooltipMargin: 8,
                      getTooltipItem: (grupo, indiceGrupo, barra, indiceBarra) {
                        final entradaCategoria = categoriasOrdenadas[grupo.x];
                        return BarTooltipItem(
                          '${entradaCategoria.key}\n',
                          TextStyle(
                            color: colorSobreSuperficie,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: formatearValorMonetario(barra.toY),
                              style: TextStyle(
                                color: barra.color,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double valorEje, TitleMeta metaEje) {
                          final indice = valorEje.toInt();
                          if (indice >= 0 &&
                              indice < categoriasOrdenadas.length) {
                            final nombreCategoria =
                                categoriasOrdenadas[indice].key;
                            final iconoCategoria =
                                iconosCategorias[nombreCategoria] ??
                                Icons
                                    .label_important_outline; // Ícono por defecto

                            return SideTitleWidget(
                              axisSide: metaEje.axisSide,
                              space: 6.0,
                              child: Icon(
                                iconoCategoria,
                                size: 20,
                                color: colorSobreSuperficie.withAlpha(
                                  (0.8 * 255).toInt(),
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize:
                            36, // Aumentar espacio reservado para íconos
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 55,
                        interval: valorMaxY / 4,
                        getTitlesWidget: (double valorEje, TitleMeta metaEje) {
                          if (valorEje == 0 ||
                              valorEje == metaEje.max ||
                              valorEje == metaEje.max / 2 ||
                              valorEje == metaEje.max * 0.25 ||
                              valorEje == metaEje.max * 0.75) {
                            if (valorEje < 0) return const Text('');
                            return Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Text(
                                formatearValorMonetario(valorEje)
                                    .replaceAll(
                                      formateadorMoneda.currencySymbol,
                                      '',
                                    )
                                    .trim(),
                                style: TextStyle(
                                  color: colorSobreSuperficie.withAlpha(
                                    (0.7 * 255).toInt(),
                                  ),
                                  fontSize: 10,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: colorSobreSuperficie.withAlpha(
                          ((esModoOscuro ? 0.3 : 0.2) * 255).toInt(),
                        ),
                        width: 1.5,
                      ),
                      left: BorderSide(
                        color: colorSobreSuperficie.withAlpha(
                          ((esModoOscuro ? 0.3 : 0.2) * 255).toInt(),
                        ),
                        width: 1.5,
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: valorMaxY / 4,
                    getDrawingHorizontalLine: (valorEje) {
                      return FlLine(
                        color: colorSobreSuperficie.withAlpha(
                          ((esModoOscuro ? 0.1 : 0.07) * 255).toInt(),
                        ),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barGroups: gruposBarras,
                ),
                swapAnimationDuration: const Duration(milliseconds: 250),
                swapAnimationCurve: Curves.linear,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
