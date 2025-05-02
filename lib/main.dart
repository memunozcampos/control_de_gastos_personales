// El código de las vistas está hardcodeado para mostrar datos ficticios de gastos.
import 'package:flutter/material.dart';
import '/modelos/gastos.dart';
import '/servicios/gestion_gastos.dart';
import '/vistas/agregar_gasto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _insertarDatosFicticios(); // Insertar datos al iniciar
  runApp(MyApp());
}

// Función para agregar gastos de prueba
Future<void> _insertarDatosFicticios() async {
  final gestor = GestorGastos();
  final List<Gasto> gastos = [
    Gasto(
      descripcion: "Cena en restaurante",
      categoria: "Alimentación",
      monto: 45.75,
      fecha: DateTime(2023, 10, 20),
    ),
    Gasto(
      descripcion: "Gasolina",
      categoria: "Transporte",
      monto: 30.00,
      fecha: DateTime(2023, 10, 21),
    ),
  ];

  for (var gasto in gastos) {
    await gestor.insertarGasto(gasto);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Gastos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PantallaInicio(),
    );
  }
}

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
          _ResumenGastos(total: _totalGastos),
          // Lista de Gastos
          Expanded(
            child: ListView.builder(
              itemCount: _gastos.length,
              itemBuilder: (context, index) {
                final gasto = _gastos[index];
                return ListTile(
                  title: Text(gasto.descripcion),
                  subtitle: Text(
                    '${gasto.categoria} - ${gasto.fecha.toString().substring(0, 10)}',
                  ),
                  trailing: Text('\$${gasto.monto.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PantallaAgregarGasto()),
          );
          _cargarGastos(); // Actualizar lista al regresar
        },
      ),
    );
  }
}

// Widget para mostrar el resumen de gastos
class _ResumenGastos extends StatelessWidget {
  final double total;

  const _ResumenGastos({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.blue[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Gastado:', style: TextStyle(fontSize: 18)),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
