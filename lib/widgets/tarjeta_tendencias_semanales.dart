import 'package:flutter/material.dart';

class TarjetaTendenciasSemanales extends StatelessWidget {
  final double cambioPorcentual;
  final bool tendenciaPositiva;

  const TarjetaTendenciasSemanales({
    super.key,
    required this.cambioPorcentual,
    required this.tendenciaPositiva,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    String textoTendencia;
    IconData iconoTendencia;
    Color colorTendencia;

    if (cambioPorcentual == 0 && !tendenciaPositiva) {
      textoTendencia = "No hay suficientes datos para tendencias semanales.";
      iconoTendencia = Icons.trending_flat;
      colorTendencia = tema.colorScheme.onSurface.withAlpha(
        (0.7 * 255).toInt(),
      );
    } else if (tendenciaPositiva) {
      textoTendencia =
          "Tus gastos han aumentado un ${cambioPorcentual.toStringAsFixed(1)}% esta semana.";
      iconoTendencia = Icons.trending_up;
      colorTendencia = Colors.redAccent;
    } else if (cambioPorcentual < 0) {
      textoTendencia =
          "Tus gastos han disminuido un ${(cambioPorcentual * -1).toStringAsFixed(1)}% esta semana.";
      iconoTendencia = Icons.trending_down;
      colorTendencia = tema.colorScheme.primary;
    } else {
      textoTendencia = "Tus gastos se mantienen estables esta semana.";
      iconoTendencia = Icons.trending_flat;
      colorTendencia = tema.colorScheme.onSurface.withAlpha(
        (0.7 * 255).toInt(),
      );
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
                    "Tendencias Semanales",
                    style: tema.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    textoTendencia,
                    style: tema.textTheme.bodyLarge?.copyWith(
                      color: colorTendencia,
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
