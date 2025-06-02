import 'package:control_de_gastos_personales/widgets/tarjeta_tendencias_semanales.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../modelos/gastos.dart';
import '../utilidades/funciones_utiles.dart';
import '../widgets/grafico_gastos_por_categoria.dart'
    show GraficoGastosPorCategoria;
import '../widgets/grafico_tendencias.dart' show GraficoTendencias;
import '../widgets/boton_selector_tema.dart' show BotonSelectorTema;
import '../widgets/tarjeta_categoria_con_mayor_gasto.dart'
    show TarjetaCategoriaConMayorGasto;
import '../widgets/tarjeta_gasto_mensual.dart' show TarjetaBalanceMensual;
import '../widgets/tarjeta_gastos_extremos.dart' show TarjetaGastosExtremos;
import '../widgets/tarjeta_promedio_diario.dart' show TarjetaPromedioDiario;

class VistaEstadisticas extends StatefulWidget {
  final List<Gasto> gastos;

  const VistaEstadisticas({super.key, required this.gastos});

  @override
  State<VistaEstadisticas> createState() => _EstadoVistaEstadisticas();
}

class _EstadoVistaEstadisticas extends State<VistaEstadisticas> {
  bool _cargando = true;
  List<Gasto> _listaGastos = [];
  String? _mensajeError;

  double _gastoTotalMesActual = 0;
  double _gastoTotalMesAnterior = 0;
  double _promedioGastoDiario = 0;
  MapEntry<String, double>? _categoriaConMayorGasto;
  Gasto? _gastoIndividualMasAlto;
  Gasto? _gastoIndividualMasBajo;
  double _cambioPorcentualSemanal = 0;
  bool _aumentaronGastosSemana = false;

  Map<String, double> _mapaGastosPorCategoria = {};
  List<Map<int, double>> _listaGastosPorSemana = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    _cargarYCalcularEstadisticas();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _cargarYCalcularEstadisticas() async {
    setState(() {
      _cargando = true;
      _mensajeError = null;
    });
    try {
      if (!mounted) return;

      setState(() {
        _listaGastos = widget.gastos;
        if (_listaGastos.isEmpty) {
          _cargando = false;
          return;
        }

        _calcularBalanceMensual();
        _calcularPromedioGastoDiario();
        _calcularMapaGastosPorCategoria();
        _calcularGastosExtremos();
        _calcularTendenciasSemanales();

        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mensajeError = "Error al cargar estadísticas: ${e.toString()}";
        _cargando = false;
      });
    }
  }

  void _calcularBalanceMensual() {
    final ahora = DateTime.now();
    final inicioMesActual = DateTime(ahora.year, ahora.month, 1);
    final finMesActual = DateTime(ahora.year, ahora.month + 1, 0, 23, 59, 59);

    final inicioMesAnterior = DateTime(ahora.year, ahora.month - 1, 1);
    final finMesAnterior = DateTime(ahora.year, ahora.month, 0, 23, 59, 59);

    _gastoTotalMesActual = _listaGastos
        .where(
          (gasto) =>
              !gasto.fecha.isBefore(inicioMesActual) &&
              !gasto.fecha.isAfter(finMesActual),
        )
        .fold(0.0, acumuladorGastos);

    _gastoTotalMesAnterior = _listaGastos
        .where(
          (gasto) =>
              !gasto.fecha.isBefore(inicioMesAnterior) &&
              !gasto.fecha.isAfter(finMesAnterior),
        )
        .fold(0.0, acumuladorGastos);
  }

  void _calcularPromedioGastoDiario() {
    if (_listaGastos.isEmpty) {
      _promedioGastoDiario = 0;
      return;
    }
    final diasUnicosConGastos =
        _listaGastos
            .map(
              (gasto) => DateTime(
                gasto.fecha.year,
                gasto.fecha.month,
                gasto.fecha.day,
              ),
            )
            .toSet();

    if (diasUnicosConGastos.isEmpty) {
      _promedioGastoDiario = 0;
      return;
    }
    final totalGastadoGeneral = _listaGastos.fold(0.0, acumuladorGastos);
    _promedioGastoDiario = totalGastadoGeneral / diasUnicosConGastos.length;
  }

  void _calcularMapaGastosPorCategoria() {
    _mapaGastosPorCategoria = groupBy(
      _listaGastos,
      (gasto) => gasto.categoria,
    ).map(
      (categoria, gastosEnCategoria) =>
          MapEntry(categoria, gastosEnCategoria.fold(0.0, acumuladorGastos)),
    );

    if (_mapaGastosPorCategoria.isNotEmpty) {
      _categoriaConMayorGasto = _mapaGastosPorCategoria.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
    } else {
      _categoriaConMayorGasto = null;
    }
  }

  void _calcularGastosExtremos() {
    if (_listaGastos.isEmpty) {
      _gastoIndividualMasAlto = null;
      _gastoIndividualMasBajo = null;
      return;
    }
    _gastoIndividualMasAlto = _listaGastos.reduce(comparadorGastoMayor);
    _gastoIndividualMasBajo = _listaGastos.reduce(comparadorGastoMenor);
  }

  int _obtenerSemanaDelAnio(DateTime fecha) {
    final diaDelAnio = extraerDiaDelAnio(fecha);
    final diaDeSemana = fecha.weekday;
    return ((diaDelAnio - diaDeSemana + 10) / 7).floor();
  }

  void _calcularTendenciasSemanales() {
    if (_listaGastos.isEmpty) {
      _listaGastosPorSemana = [];
      _cambioPorcentualSemanal = 0;
      _aumentaronGastosSemana = false;
      return;
    }

    final mapaGastosAgrupadosPorSemana = groupBy(_listaGastos, (Gasto gasto) {
      return "${gasto.fecha.year}-${_obtenerSemanaDelAnio(gasto.fecha)}";
    });

    List<MapEntry<String, double>> listaSemanasConGastos =
        mapaGastosAgrupadosPorSemana.entries.map((entrada) {
          final totalGastoSemana = entrada.value.fold(0.0, acumuladorGastos);
          return MapEntry(entrada.key, totalGastoSemana);
        }).toList();

    listaSemanasConGastos.sort((a, b) {
      final partesA = a.key.split('-');
      final partesB = b.key.split('-');
      final anioA = int.parse(partesA[0]);
      final semanaA = int.parse(partesA[1]);
      final anioB = int.parse(partesB[0]);
      final semanaB = int.parse(partesB[1]);

      if (anioA != anioB) return anioA.compareTo(anioB);
      return semanaA.compareTo(semanaB);
    });

    _listaGastosPorSemana =
        listaSemanasConGastos.map((entrada) {
          final numeroSemana = int.parse(entrada.key.split('-')[1]);
          return {numeroSemana: entrada.value};
        }).toList();

    if (_listaGastosPorSemana.length >= 2) {
      final totalGastoSemanaMasReciente =
          _listaGastosPorSemana.last.values.first;
      final totalGastoSemanaPenultima =
          _listaGastosPorSemana[_listaGastosPorSemana.length - 2].values.first;

      if (totalGastoSemanaPenultima > 0) {
        _cambioPorcentualSemanal =
            ((totalGastoSemanaMasReciente - totalGastoSemanaPenultima) /
                totalGastoSemanaPenultima) *
            100;
        _aumentaronGastosSemana =
            totalGastoSemanaMasReciente > totalGastoSemanaPenultima;
      } else if (totalGastoSemanaMasReciente > 0) {
        _cambioPorcentualSemanal = 100;
        _aumentaronGastosSemana = true;
      } else {
        _cambioPorcentualSemanal = 0;
        _aumentaronGastosSemana = false;
      }
    } else {
      _cambioPorcentualSemanal = 0;
      _aumentaronGastosSemana = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    Text titulo = Text('Estadísticas');

    if (_cargando) {
      return Scaffold(
        appBar: AppBar(title: titulo, actions: [BotonSelectorTema()]),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_mensajeError != null) {
      return Scaffold(
        appBar: AppBar(title: titulo, actions: [BotonSelectorTema()]),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _mensajeError!,
              style: TextStyle(color: tema.colorScheme.error, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (_listaGastos.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: titulo, actions: [BotonSelectorTema()]),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No hay gastos registrados para mostrar estadísticas.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: titulo, actions: [BotonSelectorTema()]),
      body: RefreshIndicator(
        onRefresh: _cargarYCalcularEstadisticas,
        color: tema.colorScheme.primary,
        backgroundColor: tema.colorScheme.surface,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TarjetaBalanceMensual(
              gastoMesActual: _gastoTotalMesActual,
              gastoMesAnterior: _gastoTotalMesAnterior,
            ),
            const SizedBox(height: 16),
            TarjetaPromedioDiario(promedioDiario: _promedioGastoDiario),
            const SizedBox(height: 16),
            TarjetaCategoriaConMayorGasto(
              categoriaConMayorGasto: _categoriaConMayorGasto,
            ),
            const SizedBox(height: 16),
            if (_mapaGastosPorCategoria.isNotEmpty)
              GraficoGastosPorCategoria(
                gastosPorCategoria: _mapaGastosPorCategoria,
              ),
            const SizedBox(height: 16),
            TarjetaGastosExtremos(
              gastoIndividualMasAlto: _gastoIndividualMasAlto,
              gastoIndividualMasBajo: _gastoIndividualMasBajo,
            ),
            const SizedBox(height: 16),
            TarjetaTendenciasSemanales(
              cambioPorcentual: _cambioPorcentualSemanal,
              tendenciaPositiva: _aumentaronGastosSemana,
            ),
            const SizedBox(height: 16),
            if (_listaGastosPorSemana.length >= 2)
              GraficoTendencias(datosSemanales: _listaGastosPorSemana),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
