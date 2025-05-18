import 'package:flutter/material.dart';

Widget crearTarjetaInformativa(
  BuildContext context, {
  required IconData icono,
  required String titulo,
  required List<Widget> listaWidgetsContenido,
  Color? colorIcono,
}) {
  final tema = Theme.of(context);
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 36, color: colorIcono ?? tema.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: tema.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                ...listaWidgetsContenido,
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
