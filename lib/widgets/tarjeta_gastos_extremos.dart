import 'package:control_de_gastos_personales/modelos/gastos.dart';
import 'package:flutter/material.dart';

import '../utilidades/funciones_utiles.dart' show formatearValorMonetario;
import 'tarjeta_informativa.dart';

class TarjetaGastosExtremos extends StatelessWidget {
  final Gasto? gastoIndividualMasAlto;
  final Gasto? gastoIndividualMasBajo;

  const TarjetaGastosExtremos({
    super.key,
    required this.gastoIndividualMasAlto,
    required this.gastoIndividualMasBajo,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    if (gastoIndividualMasAlto == null || gastoIndividualMasBajo == null) {
      return crearTarjetaInformativa(
        context,
        icono: Icons.swap_vert_circle_outlined,
        titulo: "Extremos de Gastos",
        listaWidgetsContenido: [
          Text("No hay suficientes datos.", style: tema.textTheme.bodyLarge),
        ],
      );
    }

    return crearTarjetaInformativa(
      context,
      icono: Icons.swap_vert_circle_outlined,
      titulo: "Extremos de Gastos",
      listaWidgetsContenido: [
        Text.rich(
          TextSpan(
            children: [
              const WidgetSpan(
                child: Icon(
                  Icons.arrow_circle_up_outlined,
                  color: Colors.redAccent,
                  size: 18,
                ),
              ),
              const TextSpan(text: " Mayor: "),
              TextSpan(
                text: gastoIndividualMasAlto!.descripcion,
                style: tema.textTheme.bodyMedium,
              ),
              TextSpan(
                text:
                    " (${formatearValorMonetario(gastoIndividualMasAlto!.monto)})",
                style: tema.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  Icons.arrow_circle_down_outlined,
                  color: tema.colorScheme.primary,
                  size: 18,
                ),
              ),
              const TextSpan(text: " Menor: "),
              TextSpan(
                text: gastoIndividualMasBajo!.descripcion,
                style: tema.textTheme.bodyMedium,
              ),
              TextSpan(
                text:
                    " (${formatearValorMonetario(gastoIndividualMasBajo!.monto)})",
                style: tema.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
