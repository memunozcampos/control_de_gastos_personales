// Diálogo para eliminar gastos
import 'package:flutter/material.dart';

class DialogoConfirmacion extends StatelessWidget {
  final String titulo;
  final String mensaje;
  final VoidCallback onConfirmar;

  // ignore: use_super_parameters
  const DialogoConfirmacion({
    Key? key,
    required this.titulo,
    required this.mensaje,
    required this.onConfirmar,
  }) : super(key: key);

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
            onConfirmar(); // Ejecuta la acción de eliminación
          },
          child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
