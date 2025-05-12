class Gasto {
  int? id; // Este será asignado por la base de datos
  String categoria;
  String descripcion;
  DateTime fecha;
  double monto;

  Gasto({
    this.id,
    required this.categoria,
    required this.descripcion,
    required this.fecha,
    required this.monto,
  });

  // Convertir objeto Gasto a Map (para SQLite)
  Map<String, dynamic> convertirAMap() {
    return {
      'id': id,
      'descripcion': descripcion,
      'categoria': categoria,
      'monto': monto,
      'fecha': fecha.toIso8601String(),
    };
  }

  // Convertir Map a objeto Gasto (desde SQLite)
  factory Gasto.convertirDesdeMap(Map<String, dynamic> mapa) {
    return Gasto(
      id: mapa['id'],
      descripcion: mapa['descripcion'],
      categoria: mapa['categoria'],
      monto: mapa['monto'],
      fecha: DateTime.parse(mapa['fecha']),
    );
  }
}
