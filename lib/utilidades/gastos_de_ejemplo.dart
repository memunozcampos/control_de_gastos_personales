import '/modelos/gastos.dart';
import '/servicios/gestion_gastos.dart';

// Función para agregar gastos de prueba
Future<void> insertarDatosFicticios() async {
  final gestor = GestorGastos();
  final List<Gasto> gastos = [
    Gasto(
      descripcion: "Cena en restaurante medio de luxe",
      categoria: "Alimentación",
      monto: 45.75,
      fecha: DateTime(2023, 10, 20),
    ),
    Gasto(
      descripcion: "Gasolina para ir al trabajo",
      categoria: "Transporte",
      monto: 30.00,
      fecha: DateTime(2023, 10, 21),
    ),
    Gasto(
      descripcion: "Gasolina para ir a la playa",
      categoria: "Transporte",
      monto: 15.00,
      fecha: DateTime(2023, 10, 26),
    ),
  ];

  for (var gasto in gastos) {
    await gestor.insertarGasto(gasto);
  }
}
