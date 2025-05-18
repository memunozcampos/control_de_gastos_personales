import 'package:flutter/material.dart';

import '../utilidades/funciones_utiles.dart' show formatearValorMonetario;

class TarjetaBalanceMensual extends StatelessWidget {
  final double gastoMesActual;
  final double gastoMesAnterior;

  const TarjetaBalanceMensual({
    super.key,
    required this.gastoMesActual,
    required this.gastoMesAnterior,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    String detalleBalance;
    IconData iconoTendencia;
    Color colorTendencia;

    if (gastoMesActual > gastoMesAnterior) {
      detalleBalance = "🔼 Gastaste más este mes";
      iconoTendencia = Icons.arrow_upward;
      colorTendencia = Colors.redAccent;
    } else if (gastoMesActual < gastoMesAnterior) {
      detalleBalance = "🔽 Gastaste menos este mes";
      iconoTendencia = Icons.arrow_downward;
      colorTendencia = tema.colorScheme.primary;
    } else {
      detalleBalance = "↔️ Mismo gasto que el mes pasado";
      iconoTendencia = Icons.compare_arrows;
      colorTendencia = tema.colorScheme.onSurface.withAlpha(
        (0.7 * 255).toInt(),
      );
    }

    // Casos especiales cuando algún mes tiene 0 gastos
    if (gastoMesAnterior == 0 && gastoMesActual > 0) {
      detalleBalance = "🔼 Empezaste a gastar este mes";
    } else if (gastoMesAnterior > 0 && gastoMesActual == 0) {
      detalleBalance =
          "✅ Sin gastos este mes (anterior: ${formatearValorMonetario(gastoMesAnterior)})";
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(iconoTendencia, size: 36, color: colorTendencia),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Balance Mensual",
                    style: tema.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Este mes: ${formatearValorMonetario(gastoMesActual)}",
                    style: tema.textTheme.bodyLarge,
                  ),
                  Text(
                    "Mes pasado: ${formatearValorMonetario(gastoMesAnterior)}",
                    style: tema.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detalleBalance,
                    style: tema.textTheme.bodyMedium?.copyWith(
                      color: colorTendencia,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
