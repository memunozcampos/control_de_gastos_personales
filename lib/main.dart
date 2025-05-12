import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'vistas/pantalla_inicial.dart';
// Importa la funcion que genera datos de ejemplo
//import '/utilidades/gastos_de_ejemplo.dart';

void main() async {
  sqfliteFfiInit();
  //databaseFactory = databaseFactoryFfi;

  WidgetsFlutterBinding.ensureInitialized();
  //await insertarDatosFicticios(); // Inserta datos ficticios al iniciar la app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Gastos Personales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PantallaInicio(),
    );
  }
}
