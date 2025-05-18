// Widget reutilizable de la lista de gastos.

import 'package:flutter/material.dart';
import '../modelos/gastos.dart';
import 'tarjeta_gasto.dart';

class ListaGastos extends StatelessWidget {
  final List<Gasto> gastos;
  final VoidCallback actualizadorDeEstado;
  final GlobalKey claveTutorial;
  const ListaGastos({
    super.key,
    required this.gastos,
    required this.actualizadorDeEstado,
    required this.claveTutorial,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(
            top: 50,
          ), // Ajusta según altura del título
          itemCount: gastos.length,
          itemBuilder: (context, index) {
            return TarjetaGasto(
              gasto: gastos[index],
              actualizadorDeEstado: actualizadorDeEstado,
              claveProvista: index == 0 ? claveTutorial : null,
            );
          },
        ),

        // Título flotante
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Detalle de Gastos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
