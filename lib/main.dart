import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:provider/provider.dart';
import 'vistas/pantalla_inicio.dart';
import 'temas/modo_claro.dart';
import 'temas/modo_oscuro.dart';
import 'temas/gestion_temas.dart';
// Importa la funcion que genera datos de ejemplo
//import '/utilidades/gastos_de_ejemplo.dart';

void main() async {
  sqfliteFfiInit();
  WidgetsFlutterBinding.ensureInitialized();

  //databaseFactory = databaseFactoryFfi;

  final proveedorDeTema = GestorTemaAplicacion();
  await proveedorDeTema.cargarTema();

  //await insertarDatosFicticios(); // Inserta datos ficticios al iniciar la app
  runApp(
    ChangeNotifierProvider.value(value: proveedorDeTema, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GestorTemaAplicacion>(
      builder: (context, proveedorDeTema, child) {
        return MaterialApp(
          title: 'Control de Gastos Personales',
          debugShowCheckedModeBanner: false,
          theme: temaDeAplicacion,
          darkTheme: temaOscuroDeAplicacion,
          themeMode: proveedorDeTema.modoDeTema,
          home: const PantallaInicio(),
        );
      },
    );
  }
}
