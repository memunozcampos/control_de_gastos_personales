import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../servicios/gestion_gastos.dart';
import 'dialogo_confirmar_eliminacion.dart' show DialogoConfirmacion;

class BotonEliminarGastos extends StatefulWidget {
  final VoidCallback actualizadorDeEstado;
  final GlobalKey? claveBorrarTodo;

  const BotonEliminarGastos({
    super.key,
    required this.actualizadorDeEstado,
    this.claveBorrarTodo,
  });

  @override
  State<BotonEliminarGastos> createState() => _BotonEliminarGastosState();
}

class _BotonEliminarGastosState extends State<BotonEliminarGastos> {
  bool _botonVisible = true;

  @override
  void initState() {
    super.initState();
    _verificarEstadoBoton();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _verificarEstadoBoton() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool botonYaUsado = prefs.getBool('botonEliminarUsado') ?? false;

    setState(() {
      _botonVisible = !botonYaUsado;
    });
  }

  Future<void> _eliminarRegistros() async {
    try {
      await GestorGastos().eliminarTodosLosGastos();
      widget.actualizadorDeEstado();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('botonEliminarUsado', true);

      setState(() {
        _botonVisible = false; // Ocultar el botón después de usarlo
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Todos los registros han sido eliminados",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error al eliminar registros: ${e.toString()}",
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _botonVisible
        ? IconButton(
          key: widget.claveBorrarTodo ?? const Key('botonEliminarGastos'),
          icon: Icon(Icons.delete_forever, color: Colors.red),
          tooltip: "Eliminar todos los registros",
          onPressed: () async {
            final confirmacion = await showDialog<bool>(
              context: context,
              builder:
                  (context) => DialogoConfirmacion(
                    titulo: 'Confirmar Eliminación',
                    mensaje: '¿Estás seguro de eliminar todos los gastos',
                  ),
            );
            if (confirmacion!) {
              await _eliminarRegistros();
            }
          },
        )
        : SizedBox(); // Retorna un widget vacío si el botón ya fue usado
  }
}
