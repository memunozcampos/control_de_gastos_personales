import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../widgets/boton_eliminar_gastos.dart';
import 'vista_gasto.dart';
import '../modelos/gastos.dart';
import '../servicios/gestion_gastos.dart';
import '../widgets/lista_gastos.dart';
import '../widgets/resumen_de_gastos.dart';
import '../widgets/boton_selector_tema.dart';

class VistaInicio extends StatefulWidget {
  const VistaInicio({super.key});

  @override
  State<VistaInicio> createState() => _EstadoVistaInicio();
}

class _EstadoVistaInicio extends State<VistaInicio> {
  final GestorGastos _gestor = GestorGastos();
  bool _cargando = true;
  String? _mensajeError;
  List<Gasto> _gastos = [];

  final GlobalKey _claveVistaGasto = GlobalKey();
  final GlobalKey _claveTarjetaGasto = GlobalKey();
  final GlobalKey _claveVistaResumen = GlobalKey();
  final GlobalKey _claveBorrarTodo = GlobalKey();
  final GlobalKey _claveCambiarTema = GlobalKey();

  final List<TargetFocus> _objetivos = [];
  TutorialCoachMark? _tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    _cargarGastos();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(seconds: 1),
        () => _mostrarTutorialSiEsPrimerUso(),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _mostrarTutorialSiEsPrimerUso() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    const String clavePrimerUsoTutorial = 'primerUsoTutorial';
    bool esPrimerUso = prefs.getBool(clavePrimerUsoTutorial) ?? true;

    if (esPrimerUso) {
      _definirObjetivosTutorial();
      _tutorialCoachMark = TutorialCoachMark(
        targets: _objetivos,
        colorShadow: Colors.black,
        textSkip: "Saltar",
        hideSkip: true,
        onClickTarget: (target) async {
          debugPrint("Tocaste el objetivo: ${target.identify}");
        },
        onFinish: () async {
          await prefs.setBool(clavePrimerUsoTutorial, false);
          debugPrint("Tutorial finalizado");
        },
      );
      if (!mounted) return;
      _tutorialCoachMark!.show(context: context);
    }
  }

  void _definirObjetivosTutorial() {
    _objetivos.clear();

    // 1. Objetivo: FloatingActionButton para agregar gasto
    _objetivos.add(
      TargetFocus(
        identify: "agregar_gasto",
        keyTarget: _claveVistaGasto,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Text(
              '''➕ Agregas un gasto tocando este botón.
Por ahora, tócalo para continuar. 😅''',
              style: TextStyle(fontSize: 16, color: Colors.amber),
            ),
          ),
        ],
      ),
    );

    // 2. Objetivo: Tocar brevemente un gasto para ver sus detalles
    _objetivos.add(
      TargetFocus(
        identify: "trabajar_con_gastos",
        keyTarget: _claveTarjetaGasto,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(top: 10, left: 0),
            child: Text(
              ''' Hay tres acciones que puedes realizar con un gasto:
✅ Si tocas brevemente un gasto, puedes ver sus detalles. 👆
✅ Al mantener presionado un gasto, se puede editar. 👆👆
✅ Si deslizas un gasto a la derecha, puedes eliminarlo. 👉

Toca el primer gasto para continuar.''',
              style: TextStyle(fontSize: 16, color: Colors.amber),
            ),
          ),
        ],
        paddingFocus: 0,
        shape: ShapeLightFocus.RRect,
      ),
    );

    // 3. Objetivo: Ver las estadísticas de gastos
    _objetivos.add(
      TargetFocus(
        identify: "ver_estadisticas",
        keyTarget: _claveVistaResumen,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Text(
              '''🤓📈
Toca el resumen para ver más estadísticas sobre tus gastos.''',
              style: TextStyle(
                fontSize: 16,
                color: Colors.amberAccent,
                backgroundColor: const Color.fromARGB(94, 0, 0, 0),
              ),
            ),
          ),
        ],
        paddingFocus: 0,
        shape: ShapeLightFocus.RRect,
      ),
    );

    // 4. Objetivo: Borrar todos los gastos de ejemplo
    _objetivos.add(
      TargetFocus(
        identify: "borrar_todo",
        keyTarget: _claveBorrarTodo,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Text(
              '''🚮 Toca el botón para borrar todos los gastos de ejemplo e iniciar tus propios datos.
(⚠ Como dice el pato lucas:
"Este truco solo se puede hacer una vez" 😅)
              ''',
              style: TextStyle(fontSize: 16, color: Colors.amberAccent),
            ),
          ),
        ],
      ),
    );

    // 5. Objetivo: Cambiar el tema del modo claro a oscuro
    _objetivos.add(
      TargetFocus(
        identify: "cambiar_tema",
        keyTarget: _claveCambiarTema,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Text(
              "🌞🌜 Toca el botón para cambiar el tema de la aplicación a modo oscuro y viceversa.",
              style: TextStyle(fontSize: 16, color: Colors.amberAccent),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cargarGastos() async {
    setState(() {
      _cargando = true;
      _mensajeError = null;
    });
    try {
      final gastos = await _gestor.obtenerGastos();
      if (!mounted) return;
      setState(() {
        _gastos = gastos;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mensajeError = "Error al cargar gastos: ${e.toString()}";
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData tema = Theme.of(context);
    final titulo = const Text('Mis Gastos');

    if (_cargando) {
      return Scaffold(
        appBar: AppBar(title: titulo, actions: [BotonSelectorTema()]),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_mensajeError != null) {
      return Scaffold(
        appBar: AppBar(title: titulo, actions: [BotonSelectorTema()]),
        body: Center(child: Text(_mensajeError!)),
      );
    }

    if (_gastos.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: titulo, actions: [BotonSelectorTema()]),
        body: const Center(child: Text('No hay gastos registrados')),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VistaGasto(actualizadorDeEstado: _cargarGastos),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: titulo,
        actions: [
          BotonEliminarGastos(
            actualizadorDeEstado: _cargarGastos,
            claveBorrarTodo: _claveBorrarTodo,
          ),
          BotonSelectorTema(claveCambiarTema: _claveCambiarTema),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _cargarGastos,
        color: tema.colorScheme.primary,
        backgroundColor: tema.colorScheme.surface,
        child: Column(
          children: [
            // Se envuelve ResumenDeGastos en un GestureDetector para asignarle la clave (_claveVistaResumen)
            GestureDetector(
              key: _claveVistaResumen,
              onTap: () {
                // Navegar a VistaEstadisticas (asegúrate de definir la ruta o implementarlo)
                Navigator.pushNamed(context, '/vistaEstadisticas');
              },
              child: ResumenDeGastos(gastos: _gastos),
            ),
            Expanded(
              // Se asume que ListaGastos permite recibir una clave para el primer dismissable mediante el parámetro "keyDismissable"
              child: ListaGastos(
                gastos: _gastos,
                actualizadorDeEstado: _cargarGastos,
                claveTutorial: _claveTarjetaGasto,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: _claveVistaGasto,
        tooltip: 'Agregar nuevo gasto',
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VistaGasto(actualizadorDeEstado: _cargarGastos),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
