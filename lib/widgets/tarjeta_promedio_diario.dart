import 'package:flutter/material.dart';

import '../utilidades/funciones_utiles.dart' show formatearValorMonetario;
import 'tarjeta_informativa.dart' show crearTarjetaInformativa;

class TarjetaPromedioDiario extends StatelessWidget {
  final double promedioDiario;

  const TarjetaPromedioDiario({super.key, required this.promedioDiario});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return crearTarjetaInformativa(
      context,
      icono: Icons.calculate_outlined,
      titulo: "Gasto Promedio Diario",
      listaWidgetsContenido: [
        Text(
          formatearValorMonetario(promedioDiario),
          style: tema.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Promedio por día con actividad.",
          style: tema.textTheme.bodySmall,
        ),
      ],
    );
  }
}
