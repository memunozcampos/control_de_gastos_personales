// El código de las vistas está hardcodeado para mostrar datos ficticios de gastos.
import 'package:flutter/material.dart';
import '../modelos/gastos.dart';
import '../servicios/gestion_gastos.dart';
import '../utilidades/validadores.dart';

class PantallaAgregarGasto extends StatefulWidget {
  const PantallaAgregarGasto({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PantallaAgregarGastoState createState() => _PantallaAgregarGastoState();
}

class _PantallaAgregarGastoState extends State<PantallaAgregarGasto> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  final List<String> _categorias = [
    'Alimentación',
    'Transporte',
    'Ocio',
    'Otros',
  ];
  String _categoriaSeleccionada = 'Alimentación';
  DateTime? _fechaSeleccionada;

  Future<void> _seleccionarFecha(BuildContext context) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (fecha != null) {
      setState(() => _fechaSeleccionada = fecha);
    }
  }

  Future<void> _guardarGasto() async {
    if (_formKey.currentState!.validate() && _fechaSeleccionada != null) {
      final nuevoGasto = Gasto(
        descripcion: _descripcionController.text,
        categoria: _categoriaSeleccionada,
        monto: double.parse(_montoController.text),
        fecha: _fechaSeleccionada!,
      );

      await GestorGastos().insertarGasto(nuevoGasto);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Gasto'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _guardarGasto)],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo: Descripción
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  validator:
                      (valor) => validarCampoNoVacio(valor, 'La descripción'),
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
                  decoration: InputDecoration(labelText: 'Categoría'),
                ),
                // Campo: Monto
                TextFormField(
                  controller: _montoController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Monto'),
                  validator: validarMonto,
                ),
                // Campo: Fecha
                TextFormField(
                  readOnly: true,
                  onTap: () => _seleccionarFecha(context),
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text:
                        _fechaSeleccionada?.toString().substring(0, 10) ??
                        'Seleccionar fecha',
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
