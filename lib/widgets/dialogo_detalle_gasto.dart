import 'package:control_de_gastos_personales/utilidades/funciones_utiles.dart'
    show formatearFecha, formatearValorMonetario;
import 'package:flutter/material.dart';
import '../modelos/gastos.dart';
import '../vistas/vista_gasto.dart';

class DetalleGasto extends StatelessWidget {
  final Gasto gasto;
  final VoidCallback actualizadorDeEstado;

  const DetalleGasto({
    super.key,
    required this.gasto,
    required this.actualizadorDeEstado,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatearFecha(gasto.fecha);

    return AlertDialog(
      title: const Text("Detalles del Gasto"),
      content: SingleChildScrollView(
        child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: const [
                      Icon(Icons.category),
                      SizedBox(width: 4),
                      Text(
                        "Categoría:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(gasto.categoria),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: const [
                      Icon(Icons.description),
                      SizedBox(width: 4),
                      Text(
                        "Descripción:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(gasto.descripcion),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: const [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 4),
                      Text(
                        "Fecha:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(formattedDate),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: const [
                      Icon(Icons.attach_money),
                      SizedBox(width: 4),
                      Text(
                        "Monto:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(formatearValorMonetario(gasto.monto)),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cerrar"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => VistaGasto(
                      gasto: gasto,
                      actualizadorDeEstado: actualizadorDeEstado,
                    ),
              ),
            );
          },
          child: const Text("Editar"),
        ),
      ],
    );
  }
}
