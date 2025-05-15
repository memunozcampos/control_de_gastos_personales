// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, use_super_parameters

import 'package:flutter/material.dart';
import '../modelos/gastos.dart';
import '../servicios/gestion_gastos.dart';
import '../utilidades/constantes.dart';
import '../utilidades/validadores.dart';
import '../widgets/dialogo_confirmar_eliminacion.dart';
import '../widgets/icono_selector_tema.dart';

class PantallaGasto extends StatefulWidget {
  final Gasto? gasto;
  final Function actualizadorDeEstado;

  const PantallaGasto({
    Key? key,
    this.gasto,
    required this.actualizadorDeEstado,
  }) : super(key: key);

  @override
  _EstadoPantallaGasto createState() => _EstadoPantallaGasto();
}

class _EstadoPantallaGasto extends State<PantallaGasto> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  final _categorias = iconosCategorias.keys.toList();
  String _categoriaSeleccionada = iconosCategorias.keys.toList()[0];
  DateTime? _fechaSeleccionada;

  @override
  void initState() {
    super.initState();
    if (widget.gasto != null) {
      _descripcionController.text = widget.gasto!.descripcion;
      _montoController.text = widget.gasto!.monto.toString();
      _categoriaSeleccionada = widget.gasto!.categoria;
      _fechaSeleccionada = widget.gasto!.fecha;
    }
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _montoController.dispose();
    super.dispose();
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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.gasto == null) {
        final nuevoGasto = Gasto(
          descripcion: _descripcionController.text,
          categoria: _categoriaSeleccionada,
          monto: double.parse(_montoController.text),
          fecha: _fechaSeleccionada!,
        );
        await GestorGastos().insertarGasto(nuevoGasto);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gasto agregado con éxito',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      } else {
        final gastoActualizado = Gasto(
          id: widget.gasto!.id,
          descripcion: _descripcionController.text,
          categoria: _categoriaSeleccionada,
          monto: double.parse(_montoController.text),
          fecha: _fechaSeleccionada!,
        );
        await GestorGastos().actualizarGasto(gastoActualizado);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gasto actualizado con éxito',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
      widget.actualizadorDeEstado();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo guardar el gasto. Verifica los campos.',
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _eliminarGasto() async {
    // El DialogoConfirmacion debería heredar estilos del dialogTheme
    final confirmaEliminacion = await showDialog<bool>(
      context: context,
      builder:
          (context) => DialogoConfirmacion(
            // Asumiendo que DialogoConfirmacion usa botones que heredan el tema
            titulo: 'Confirmar Eliminación',
            mensaje: '¿Estás seguro de eliminar este gasto?',
          ),
    );
    if (confirmaEliminacion == true &&
        widget.gasto != null &&
        widget.gasto!.id != null) {
      await GestorGastos().eliminarGasto(widget.gasto!.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gasto eliminado',
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      widget.actualizadorDeEstado(); // Llama para actualizar la lista
      Navigator.pop(context); // Regresa a la pantalla anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gasto == null ? 'Agregar Gasto' : 'Editar Gasto'),
        actions: [
          IconoSelectorTema(), // Icono para cambiar el tema
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          // Añade padding general al contenido del formulario
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(
                    Icons.description,
                    color: tema.colorScheme.secondary,
                  ),
                ),
                validator:
                    (valor) => validarCampoNoVacio(valor, 'La descripción'),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16.0),
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
                    (valor) => setState(() => _categoriaSeleccionada = valor!),
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  prefixIcon: Icon(
                    Icons.category,
                    color: tema.colorScheme.secondary,
                  ),
                ),
                validator:
                    (valor) => validarCampoNoVacio(valor, 'La categoría'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _montoController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Monto',
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: tema.colorScheme.secondary,
                  ),
                ),
                validator: validarMonto,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                onTap: () => _seleccionarFecha(context),
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  hintText: 'Seleccionar fecha',
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: tema.colorScheme.secondary,
                  ),
                ),
                controller: TextEditingController(
                  text:
                      _fechaSeleccionada != null
                          ? "${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}" // Formato dd/MM/yyyy
                          : '',
                ),
                validator: (_) => validarFecha(_fechaSeleccionada),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton.icon(
                icon: const Icon(Icons.save_alt_outlined),
                label: Text(
                  widget.gasto == null ? 'Agregar Gasto' : 'Guardar Cambios',
                ),
                onPressed: _guardarGasto,
                //style: ElevatedButton.styleFrom(backgroundColor: tema.colorScheme.secondary,),
              ),
              const SizedBox(height: 16.0),
              if (widget.gasto != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete_forever_outlined),
                  label: Text("Eliminar Gasto"),
                  onPressed: _eliminarGasto,
                  //style: ElevatedButton.styleFrom(backgroundColor: tema.colorScheme.secondary,),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
