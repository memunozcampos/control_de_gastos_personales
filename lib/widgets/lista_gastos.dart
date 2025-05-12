// Widget reutilizable de la lista de gastos.

import 'package:flutter/material.dart';
import '../modelos/gastos.dart';
import 'tarjeta_gasto.dart';

class ListaGastos extends StatelessWidget {
  final List<Gasto> gastos;
  final VoidCallback actualizadorDeEstado;
  const ListaGastos({
    super.key,
    required this.gastos,
    required this.actualizadorDeEstado,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: gastos.length,
      itemBuilder: (context, index) {
        return TarjetaGasto(
          gasto: gastos[index],
          actualizadorDeEstado: actualizadorDeEstado,
        );
      },
    );
  }
}
