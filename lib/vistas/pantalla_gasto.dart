// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../modelos/gastos.dart';
import '../servicios/gestion_gastos.dart';
import '../utilidades/constantes.dart';
import '../utilidades/validadores.dart';
import '../widgets/dialogo_confirmacion.dart';

class PantallaGasto extends StatefulWidget {
  final Gasto? gasto;
  final Function actualizadorDeEstado;

  // ignore: use_super_parameters
  const PantallaGasto({
    Key? key,
    this.gasto,
    required this.actualizadorDeEstado,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PantallaGastoState createState() => _PantallaGastoState();
}

class _PantallaGastoState extends State<PantallaGasto> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  final _categorias = categoriasGastos;
  String _categoriaSeleccionada = categoriasGastos[0];
  DateTime? _fechaSeleccionada;

  @override
  void initState() {
    super.initState();
    // Si se está editando un gasto, inicializa los campos con sus datos
    if (widget.gasto != null) {
      _descripcionController.text = widget.gasto!.descripcion;
      _montoController.text = widget.gasto!.monto.toString();
      _categoriaSeleccionada = widget.gasto!.categoria;
      _fechaSeleccionada = widget.gasto!.fecha;
    }
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  Future<void> _guardarGasto() async {
    if (_formKey.currentState!.validate() && _fechaSeleccionada != null) {
      // Si el gasto es nulo => agregar, sino actualizar
      if (widget.gasto == null) {
        final nuevoGasto = Gasto(
          descripcion: _descripcionController.text,
          categoria: _categoriaSeleccionada,
          monto: double.parse(_montoController.text),
          fecha: _fechaSeleccionada!,
        );
        await GestorGastos().insertarGasto(nuevoGasto);
      } else {
        final gastoActualizado = Gasto(
          id: widget.gasto!.id,
          descripcion: _descripcionController.text,
          categoria: _categoriaSeleccionada,
          monto: double.parse(_montoController.text),
          fecha: _fechaSeleccionada!,
        );
        await GestorGastos().actualizarGasto(gastoActualizado);
      }
      // Regresa a la pantalla anterior
      Navigator.pop(context);
      await widget.actualizadorDeEstado();
    }
  }

  Future<void> _eliminarGasto() async {
    await showDialog<bool>(
      context: context,
      builder:
          (context) => DialogoConfirmacion(
            titulo: 'Confirmar Eliminación',
            mensaje: '¿Estás seguro de eliminar este gasto?',
            onConfirmar: () async {
              await GestorGastos().eliminarGasto(widget.gasto!.id!);
              Navigator.pop(context); // Cerrar la pantalla de edición
              await widget
                  .actualizadorDeEstado(); // Actualiza la lista de gastos
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gasto == null ? 'Agregar Gasto' : 'Editar Gasto'),
        actions: [
          // Muestra el botón de eliminar solo si se está editando un gasto existente
          if (widget.gasto != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _eliminarGasto,
            ),
          IconButton(icon: const Icon(Icons.save), onPressed: _guardarGasto),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo: Descripción
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator:
                      (valor) => validarCampoNoVacio(valor, 'la descripción'),
                ),
                // Campo: Categoría
                DropdownButtonFormField<String>(
                  value: _categoriaSeleccionada,
                  items:
                      _categorias.map((categoria) {
                        return DropdownMenuItem(
                          value: categoria,
                          child: Text(categoria),
                        );
                      }).toList(),
                  onChanged:
                      (valor) =>
                          setState(() => _categoriaSeleccionada = valor!),
                  decoration: const InputDecoration(labelText: 'Categoría'),
                ),
                // Campo: Monto
                TextFormField(
                  controller: _montoController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Monto'),
                  validator: validarMonto,
                ),
                // Campo: Fecha
                TextFormField(
                  readOnly: true,
                  onTap: () => _seleccionarFecha(context),
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text:
                        _fechaSeleccionada != null
                            ? _fechaSeleccionada!.toString().substring(0, 10)
                            : 'Seleccionar fecha',
                  ),
                  validator: (_) => validarFechaNoFutura(_fechaSeleccionada),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
