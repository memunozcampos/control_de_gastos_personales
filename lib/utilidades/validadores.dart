// 1. Valida que los campos obligatorios no estén vacíos (excepto id)
String? validarCampoNoVacio(String? valor, [String campo = 'Este']) {
  if (valor == null || valor.trim().isEmpty) {
    return '$campo es un campo obligatorio';
  }
  return null;
}

// 2. Valida que el monto sea un número positivo con hasta dos decimales
String? validarMonto(String? valor) {
  if (valor == null || valor.isEmpty) {
    return 'Ingrese un monto';
  }

  // Verificar formato numérico
  final regex = RegExp(r'^\d+([\.\,]\d{1,2})?$');
  if (!regex.hasMatch(valor)) {
    return 'Formato inválido (ej: 25.50)';
  }

  // Convertir a double y validar que sea positivo
  final monto = double.tryParse(valor.replaceAll(',', '.')) ?? 0;
  if (monto <= 0) {
    return 'El monto debe ser mayor a cero';
  }

  return null;
}

// 3. Valida que la fecha no sea futura
String? validarFecha(DateTime? fecha) {
  if (fecha == null) {
    return 'Seleccione una fecha';
  }

  final ahora = DateTime.now();
  final fechaActual = DateTime(ahora.year, ahora.month, ahora.day);

  if (fecha.isAfter(fechaActual)) {
    return 'La fecha no puede ser futura';
  }

  return null;
}
