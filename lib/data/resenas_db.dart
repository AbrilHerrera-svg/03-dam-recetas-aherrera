import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/resena.dart';

class ResenasDb {
  ResenasDb._();
  static final ResenasDb instancia = ResenasDb._();
  static const _nombreArchivo = 'resenas.db';
  static const _tabla = 'resenas';
  Database? _db;

  // devuelve la bd abierta (la abre solo la primera vez). PdD: Singleton
  Future<Database> get _database async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), _nombreArchivo);
    return openDatabase(
      ruta,
      version: 2,
      onCreate: (db, version) async {
        await _crearTabla(db);
      },
      // v2: se quitó la columna calificacion, se recrea la tabla
      onUpgrade: (db, versionAnterior, versionNueva) async {
        await db.execute('DROP TABLE IF EXISTS $_tabla');
        await _crearTabla(db);
      },
    );
  }

  Future<void> _crearTabla(Database db) async {
    await db.execute('''
CREATE TABLE $_tabla (
id INTEGER PRIMARY KEY AUTOINCREMENT,
recetaId INTEGER NOT NULL,
autor TEXT NOT NULL,
comentario TEXT NOT NULL,
fecha TEXT NOT NULL
)
''');
  }

  // guarda y devuelve el id
  Future<int> insert(Resena resena) async {
    final db = await _database;
    return db.insert(_tabla, resena.toMap());
  }

  // lee las reseñas de una receta de manera descendente
  Future<List<Resena>> obtenerPorReceta(int recetaId) async {
    final db = await _database;
    final filas = await db.query(
      _tabla,
      where: 'recetaId = ?',
      whereArgs: [recetaId],
      orderBy: 'id DESC',
    );
    return filas.map(Resena.fromMap).toList();
  }

  // modifica usando el id
  Future<int> actualizar(Resena resena) async {
    final db = await _database;
    return db.update(
      _tabla,
      resena.toMap(),
      where: 'id = ?',
      whereArgs: [resena.id],
    );
  }

  // elimina la reseña con el id
  Future<int> eliminar(int id) async {
    final db = await _database;
    return db.delete(_tabla, where: 'id = ?', whereArgs: [id]);
  }
}
