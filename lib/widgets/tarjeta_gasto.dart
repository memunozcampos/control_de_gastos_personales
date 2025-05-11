// Widget sin estado que representa un gasto en la pantalla de inicio.
import 'package:flutter/material.dart';
import '../modelos/gastos.dart';
import '../servicios/gestion_gastos.dart';
import '../vistas/pantalla_gasto.dart'; // Asegúrate de que la ruta sea correcta
import 'dialogo_confirmacion.dart'; // Ruta hacia el widget de confirmación

class TarjetaGasto extends StatelessWidget {
  final Gasto gasto;
  final Function actualizadorDeEstado;

  // ignore: use_super_parameters
  const TarjetaGasto({
    Key? key,
    required this.gasto,
    required this.actualizadorDeEstado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(), // Asegúrate de usar un identificador único
      direction:
          DismissDirection.startToEnd, // Permite deslizar hacia la derecha
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        // Muestra el diálogo de confirmación para eliminar
        final confirmacion = await showDialog<bool>(
          context: context,
          builder:
              (context) => DialogoConfirmacion(
                titulo: 'Confirmar Eliminación',
                mensaje: '¿Estás seguro de eliminar este gasto?',
                onConfirmar: () {
                  // Aquí se podría dejar vacío o ejecutar algo opcional,
                  // ya que la eliminación se realizará en onDismissed
                },
              ),
        );
        return confirmacion ?? false;
      },
      onDismissed: (direction) {
        GestorGastos().eliminarGasto(gasto.id!);
        actualizadorDeEstado(); // Actualiza la lista de gastos
        // Además, notifica al usuario o refresca la lista según tu implementación.
      },
      child: GestureDetector(
        onTap: () {
          // Muestra un diálogo con más detalles del gasto
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text("Detalles del Gasto"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Descripción: ${gasto.descripcion}"),
                      Text("Fecha: ${gasto.fecha.toString().substring(0, 10)}"),
                      Text("Monto: \$${gasto.monto.toStringAsFixed(2)}"),
                      // Puedes agregar más detalles aquí
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cerrar"),
                    ),
                  ],
                ),
          );
        },
        onLongPress: () {
          // Abre la pantalla de edición del gasto
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PantallaGasto(
                    gasto: gasto,
                    actualizadorDeEstado: actualizadorDeEstado,
                  ),
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(gasto.descripcion),
            subtitle: Text(gasto.fecha.toString().substring(0, 10)),
            trailing: Text("\$${gasto.monto.toStringAsFixed(2)}"),
          ),
        ),
      ),
    );
  }
}
