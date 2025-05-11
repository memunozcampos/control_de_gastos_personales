// Widget reutilizable de la lista de gastos.

import 'package:flutter/material.dart';
import '../modelos/gastos.dart';
import 'tarjeta_gasto.dart';

class ListaGastos extends StatelessWidget {
  final List<Gasto> gastos;
  final Function actualizadorDeEstado; // Callback para eliminar el gasto
  //final Function onEdit; // Callback para editar el gasto
  //final Function onViewDetails; // Callback para ver detalles del gasto

  const ListaGastos({
    super.key,
    required this.gastos,
    required this.actualizadorDeEstado,
    //required this.onDelete,
    //required this.onEdit,
    //required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: gastos.length,
      itemBuilder: (context, index) {
        return TarjetaGasto(
          gasto: gastos[index],
          actualizadorDeEstado: actualizadorDeEstado,
          //onDelete: onDelete,
          //onEdit: onEdit,
          //onViewDetails: onViewDetails,
        );
      },
    );
  }
}
