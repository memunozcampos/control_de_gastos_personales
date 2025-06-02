// Diálogo para eliminar gastos
import 'package:flutter/material.dart';

class DialogoConfirmacion extends StatelessWidget {
  final String titulo;
  final String mensaje;

  const DialogoConfirmacion({
    super.key,
    required this.titulo,
    required this.mensaje,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true); // Devuelve "true" al cerrar
          },
          child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
