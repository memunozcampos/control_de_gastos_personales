import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../utilidades/funciones_utiles.dart'
    show formateadorMoneda, formatearValorMonetario;

class GraficoTendencias extends StatelessWidget {
  final List<Map<int, double>> datosSemanales;

  const GraficoTendencias({super.key, required this.datosSemanales});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colorSobreSuperficie = tema.colorScheme.onSurface;
    final colorPrimario = tema.colorScheme.primary;
    final esModoOscuro = tema.brightness == Brightness.dark;

    List<FlSpot> puntosGrafico = [];
    for (int i = 0; i < datosSemanales.length; i++) {
      puntosGrafico.add(FlSpot(i.toDouble(), datosSemanales[i].values.first));
    }

    if (puntosGrafico.length < 2) return const SizedBox.shrink();

    double valorMaxY = puntosGrafico.map((s) => s.y).reduce(max);
    valorMaxY = (valorMaxY * 1.25).ceilToDouble();
    final double valorMinY = 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Tendencia Semanal de Gastos",
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 280,
              child: LineChart(
                LineChartData(
                  minY: valorMinY,
                  maxY: valorMaxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    verticalInterval: 1,
                    horizontalInterval: valorMaxY / 4,
                    getDrawingHorizontalLine:
                        (valorEje) => FlLine(
                          color: colorSobreSuperficie.withAlpha(
                            (esModoOscuro ? 0.1 : 0.07) * 255 ~/ 1,
                          ),
                          strokeWidth: 1,
                        ),
                    getDrawingVerticalLine:
                        (valorEje) => FlLine(
                          color: colorSobreSuperficie.withAlpha(
                            (esModoOscuro ? 0.1 : 0.07) * 255 ~/ 1,
                          ),
                          strokeWidth: 1,
                        ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: const SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: datosSemanales.length > 10 ? 2 : 1,
                        getTitlesWidget: (valorEje, metaEje) {
                          final indice = valorEje.toInt();
                          if (indice >= 0 && indice < datosSemanales.length) {
                            final semana = datosSemanales[indice].keys.first;
                            return SideTitleWidget(
                              axisSide: metaEje.axisSide,
                              space: 6.0,
                              child: Text(
                                'S$semana',
                                style: TextStyle(
                                  color: colorSobreSuperficie.withAlpha(
                                    (0.8 * 255).toInt(),
                                  ),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 55,
                        interval: valorMaxY / 4,
                        getTitlesWidget: (valorEje, metaEje) {
                          if (valorEje == valorMinY ||
                              valorEje == metaEje.max ||
                              valorEje == metaEje.max / 2 ||
                              valorEje == metaEje.max * 0.25 ||
                              valorEje == metaEje.max * 0.75) {
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
                          (esModoOscuro ? 0.3 : 0.2) * 255 ~/ 1,
                        ),
                        width: 1.5,
                      ),
                      left: BorderSide(
                        color: colorSobreSuperficie.withAlpha(
                          (esModoOscuro ? 0.3 : 0.2) * 255 ~/ 1,
                        ),
                        width: 1.5,
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: puntosGrafico,
                      isCurved: true,
                      color: colorPrimario,
                      barWidth: 3.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter:
                            (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                  radius: 4,
                                  color: colorPrimario,
                                  strokeWidth: 1.5,
                                  strokeColor: tema.cardColor,
                                ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            colorPrimario.withAlpha(
                              (esModoOscuro ? 0.4 : 0.25) * 255 ~/ 1,
                            ),
                            colorPrimario.withAlpha(0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final semana =
                              datosSemanales[spot.spotIndex].keys.first;
                          return LineTooltipItem(
                            'Semana $semana\n',
                            TextStyle(
                              color: colorSobreSuperficie,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: formatearValorMonetario(spot.y),
                                style: TextStyle(
                                  color: colorPrimario,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
