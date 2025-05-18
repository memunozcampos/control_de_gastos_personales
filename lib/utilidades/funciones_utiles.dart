import 'package:intl/intl.dart';
//import 'package:intl/date_symbol_data_local.dart';

import '../modelos/gastos.dart';

final NumberFormat formateadorMoneda = NumberFormat.currency(
  locale: 'en_US',
  name: 'dólar',
  symbol: '\$',
  decimalDigits: 2,
);

final DateFormat _formateadorFecha = DateFormat('dd/MM/yyyy');

double acumuladorGastos(double suma, Gasto gasto) => suma + gasto.monto;

Gasto comparadorGastoMayor(Gasto gasto1, Gasto gasto2) =>
    gasto1.monto > gasto2.monto ? gasto1 : gasto2;

Gasto comparadorGastoMenor(Gasto gasto1, Gasto gasto2) =>
    gasto1.monto < gasto2.monto ? gasto1 : gasto2;

String formatearValorMonetario(double monto) => formateadorMoneda.format(monto);

String formatearFecha(DateTime fecha) => _formateadorFecha.format(fecha);

int extraerDiaDelAnio(DateTime fecha) =>
    int.parse(DateFormat("D", 'es_SV').format(fecha));
