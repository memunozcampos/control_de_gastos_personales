import 'package:flutter/material.dart';
import 'pantalla_gasto.dart';
import '../modelos/gastos.dart';
import '../servicios/gestion_gastos.dart';
import '../widgets/lista_gastos.dart';
import '../widgets/resumen_de_gastos.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  final GestorGastos _gestor = GestorGastos();
  List<Gasto> _gastos = [];
  double _totalGastos = 0.0;

  @override
  void initState() {
    super.initState();
    _cargarGastos();
  }

  Future<void> _cargarGastos() async {
    final gastos = await _gestor.obtenerGastos();
    setState(() {
      _gastos = gastos;
      _totalGastos = _calcularTotal(gastos);
    });
  }

  double _calcularTotal(List<Gasto> gastos) {
    return gastos.fold(0.0, (sum, gasto) => sum + gasto.monto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Gastos')),
      body: Column(
        children: [
          // Widget de Resumen
          ResumenDeGastos(totalGastos: _totalGastos),
          // Lista de Gastos
          Expanded(
            child: ListaGastos(
              gastos: _gastos,
              actualizadorDeEstado: _cargarGastos,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => PantallaGasto(actualizadorDeEstado: _cargarGastos),
            ),
          );
        },
      ),
    );
  }
}
