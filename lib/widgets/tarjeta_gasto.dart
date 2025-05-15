// Widget sin estado que representa un gasto en la pantalla de inicio.
import 'package:flutter/material.dart';
import '../modelos/gastos.dart';
import '../servicios/gestion_gastos.dart';
import '../utilidades/constantes.dart';
import '../vistas/pantalla_gasto.dart';
import 'dialogo_detalle_gasto.dart';
import 'dialogo_confirmar_eliminacion.dart'; // Ruta hacia el widget de confirmación

class TarjetaGasto extends StatelessWidget {
  final Gasto gasto;
  final VoidCallback actualizadorDeEstado;

  // ignore: use_super_parameters
  const TarjetaGasto({
    Key? key,
    required this.gasto,
    required this.actualizadorDeEstado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Dismissible(
      key: UniqueKey(),
      direction:
          DismissDirection.startToEnd, // Permite deslizar hacia la derecha
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
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
              ),
        );
        return confirmacion ?? false;
      },
      onDismissed: (direction) {
        GestorGastos().eliminarGasto(gasto.id!);
        actualizadorDeEstado();
      },
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder:
                (context) => DetalleGasto(
                  gasto: gasto,
                  actualizadorDeEstado: actualizadorDeEstado,
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
            leading: CircleAvatar(
              backgroundColor: tema.colorScheme.primary,
              child: Icon(
                iconosCategorias[gasto.categoria.toString()] ?? Icons.error,
                color: tema.colorScheme.onPrimary,
              ),
            ),
            //subtitle: Text(gasto.fecha.toString().substring(0, 10)),
            trailing: Text(
              "\$${gasto.monto.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
