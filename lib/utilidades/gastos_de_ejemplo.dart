import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart';

import '../modelos/gastos.dart' show Gasto;
import '../servicios/gestion_gastos.dart' show GestorGastos;

import 'package:shared_preferences/shared_preferences.dart';

Future<void> inicializarDatosDeEjemplo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  const String clavePrimerUsoDatos = 'primerUsoDatos';

  bool esPrimerUsoDatos = prefs.getBool(clavePrimerUsoDatos) ?? true;

  if (esPrimerUsoDatos) {
    await cargarDatosDeEjemplo();
    await prefs.setBool(clavePrimerUsoDatos, false);
  } else {
    debugPrint(
      "No es la primera vez que se abre la app. No se cargan datos de ejemplo.",
    );
  }
}

Future<void> cargarDatosDeEjemplo() async {
  try {
    final String cadenaJson = await rootBundle.loadString(
      'assets/datos_ejemplo/gastos.json',
    );

    final List<dynamic> datosJson = json.decode(cadenaJson);

    for (final item in datosJson) {
      final gasto = Gasto(
        categoria: item['categoria'],
        descripcion: item['descripcion'],
        fecha: DateTime.parse(item['fecha']),
        monto: (item['monto'] as num).toDouble(),
      );
      await GestorGastos().insertarGasto(gasto);
    }
    debugPrint('Datos de ejemplo cargados exitosamente.');
  } catch (e) {
    debugPrint('Error al cargar los datos de ejemplo: $e');
  }
}
