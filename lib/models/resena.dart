class Resena {
  final int? id;
  final int recetaId;
  final String autor;
  final String comentario;
  final int calificacion;
  final DateTime fecha;

  const Resena({
    this.id,
    required this.recetaId,
    required this.autor,
    required this.comentario,
    required this.calificacion,
    required this.fecha,
  });

  // convierte la reseña en un mapa para guardarla en la bd
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recetaId': recetaId,
      'autor': autor,
      'comentario': comentario,
      'calificacion': calificacion,
      'fecha': fecha.toIso8601String(),
    };
  }

  // crea una reseña a partir de una fila de la bd
  factory Resena.fromMap(Map<String, dynamic> mapa) {
    return Resena(
      id: mapa['id'],
      recetaId: mapa['recetaId'],
      autor: mapa['autor'],
      comentario: mapa['comentario'],
      calificacion: mapa['calificacion'],
      fecha: DateTime.parse(mapa['fecha']),
    ); // Resena
  }
}
