import 'package:flutter/material.dart';
import '../modelos/gastos.dart';
import '../servicios/gestion_gastos.dart';
import '../utilidades/constantes.dart';
import '../utilidades/validadores.dart';
import '../widgets/dialogo_confirmar_eliminacion.dart';
import '../widgets/notificacion.dart';
import '../widgets/boton_selector_tema.dart';
import '../utilidades/funciones_utiles.dart' show formatearFecha;

class VistaGasto extends StatefulWidget {
  final Gasto? gasto;
  final Function actualizadorDeEstado;

  const VistaGasto({super.key, this.gasto, required this.actualizadorDeEstado});

  @override
  State<VistaGasto> createState() => _EstadoVistaGasto();
}

class _EstadoVistaGasto extends State<VistaGasto> {
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
        if (!mounted) return;
        notificaExitoAgregacion(context);
      } else {
        final gastoActualizado = Gasto(
          id: widget.gasto!.id,
          descripcion: _descripcionController.text,
          categoria: _categoriaSeleccionada,
          monto: double.parse(_montoController.text),
          fecha: _fechaSeleccionada!,
        );
        await GestorGastos().actualizarGasto(gastoActualizado);
        if (!mounted) return;
        notificaExitoActualizacion(context);
      }
      widget.actualizadorDeEstado();
      Navigator.pop(context);
    } else {
      notificaErrorAgregacion(context);
    }
  }

  Future<void> _eliminarGasto() async {
    final confirmaEliminacion = await showDialog<bool>(
      context: context,
      builder:
          (context) => DialogoConfirmacion(
            titulo: 'Confirmar Eliminación',
            mensaje: '¿Estás seguro de eliminar este gasto?',
          ),
    );
    if (confirmaEliminacion == true &&
        widget.gasto != null &&
        widget.gasto!.id != null) {
      await GestorGastos().eliminarGasto(widget.gasto!.id!);
      if (!mounted) return;
      notificaExitoEliminacion(context);
      widget.actualizadorDeEstado();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gasto == null ? 'Agregar Gasto' : 'Editar Gasto'),
        actions: [BotonSelectorTema()],
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
                          ? formatearFecha(_fechaSeleccionada!)
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
