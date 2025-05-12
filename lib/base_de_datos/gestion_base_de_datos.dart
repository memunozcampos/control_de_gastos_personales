import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GestorBaseDeDatos {
  static final GestorBaseDeDatos _instancia = GestorBaseDeDatos._interno();
  factory GestorBaseDeDatos() => _instancia;
  static Database? _bd;

  GestorBaseDeDatos._interno(); // Constructor privado

  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await _inicializarBD();
    return _bd!;
  }

  Future<Database> _inicializarBD() async {
    final rutaBD = join(
      await getDatabasesPath(),
      'control_gastos_personales.db',
    );
    return openDatabase(rutaBD, version: 1, onCreate: _crearTablas);
  }

  Future<void> _crearTablas(Database db, int version) async {
    await db.execute('''
      CREATE TABLE gastos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoria TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        fecha TEXT NOT NULL,
        monto REAL NOT NULL
      )
    ''');
  }

  Future<void> cerrarBD() async {
    if (_bd != null) await _bd!.close();
  }
}
