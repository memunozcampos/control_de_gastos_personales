import 'package:flutter/material.dart';

import '../utilidades/constantes.dart' show iconosCategorias;
import '../utilidades/funciones_utiles.dart' show formatearValorMonetario;
import 'tarjeta_informativa.dart' show crearTarjetaInformativa;

class TarjetaCategoriaConMayorGasto extends StatelessWidget {
  final MapEntry<String, double>? categoriaConMayorGasto;

  const TarjetaCategoriaConMayorGasto({
    super.key,
    required this.categoriaConMayorGasto,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    if (categoriaConMayorGasto == null) {
      return crearTarjetaInformativa(
        context,
        icono: Icons.category_outlined,
        titulo: "Categoría Más Gastada",
        listaWidgetsContenido: [
          Text("No hay datos de categorías.", style: tema.textTheme.bodyLarge),
        ],
      );
    }

    final claveCategoria = categoriaConMayorGasto!.key;
    IconData iconoCategoria =
        iconosCategorias[claveCategoria] ?? Icons.label_important_outline;

    return crearTarjetaInformativa(
      context,
      icono: iconoCategoria,
      titulo: "Mayor Gasto: ${categoriaConMayorGasto!.key}",
      listaWidgetsContenido: [
        Text(
          formatearValorMonetario(categoriaConMayorGasto!.value),
          style: tema.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
      colorIcono: tema.colorScheme.secondary,
    );
  }
}
