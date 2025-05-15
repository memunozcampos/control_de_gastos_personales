import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GestorTemaAplicacion with ChangeNotifier {
  ThemeMode _modoDeTema = ThemeMode.light;
  final String _clavePreferenciaDeUsuario = 'temaDeUsuario';
  final String _clavePrimerUso = 'primerUso';
  bool _esPrimerUso = true;

  ThemeMode get modoDeTema => _modoDeTema;
  bool get esPrimerUso => _esPrimerUso;

  Future<void> cargarTema() async {
    final preferencias = await SharedPreferences.getInstance();
    _esPrimerUso = preferencias.getBool(_clavePrimerUso) ?? true;

    if (_esPrimerUso) {
      _modoDeTema = ThemeMode.system;
      await preferencias.setBool(_clavePrimerUso, false);
    } else {
      final indiceAlmacenado = preferencias.getInt(_clavePreferenciaDeUsuario);
      if (indiceAlmacenado != null) {
        _modoDeTema = ThemeMode.values[indiceAlmacenado];
      }
    }
    notifyListeners();
  }

  Future<void> cambiarTema() async {
    final preferencias = await SharedPreferences.getInstance();
    _modoDeTema =
        _modoDeTema == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await preferencias.setInt(_clavePreferenciaDeUsuario, _modoDeTema.index);
    notifyListeners();
  }
}
