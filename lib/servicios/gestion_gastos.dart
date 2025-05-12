import 'package:sqflite/sqflite.dart';
import '../base_de_datos/gestion_base_de_datos.dart';
import '../modelos/gastos.dart';

class GestorGastos {
  final GestorBaseDeDatos _gestorBD = GestorBaseDeDatos();

  // Insertar un gasto
  Future<int> insertarGasto(Gasto gasto) async {
    final Database bd = await _gestorBD.bd;
    final int id = await bd.insert('gastos', gasto.convertirAMap());
    return id;
  }

  // Obtener todos los gastos
  Future<List<Gasto>> obtenerGastos() async {
    final Database bd = await _gestorBD.bd;
    final List<Map<String, dynamic>> registros = await bd.query('gastos');
    return registros.map((mapa) => Gasto.convertirDesdeMap(mapa)).toList();
  }

  // Actualizar un gasto por ID
  Future<int> actualizarGasto(Gasto gasto) async {
    final Database bd = await _gestorBD.bd;
    final int numeroDeFilasAfectadas = await bd.update(
      'gastos',
      gasto.convertirAMap(),
      where: 'id = ?',
      whereArgs: [gasto.id],
    );
    return numeroDeFilasAfectadas;
  }

  // Eliminar un gasto por ID
  Future<int> eliminarGasto(int id) async {
    final Database bd = await _gestorBD.bd;
    final int numeroDeFilasAfectadas = await bd.delete(
      'gastos',
      where: 'id = ?',
      whereArgs: [id],
    );
    return numeroDeFilasAfectadas;
  }
}
