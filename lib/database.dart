import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  late final Database db;

  DatabaseService._internal() {
    final dataDir = p.join(Directory.current.path, 'data');

    final dir = Directory(dataDir);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    final dbPath = p.join(dataDir, 'biblioteca.db');

    try {
      db = sqlite3.open(dbPath);

      db.execute('PRAGMA foreign_keys = ON;');

      _createTables();
    } catch (e) {
      print('Erro ao inicializar banco: $e');
      rethrow;
    }
  }

  void _createTables() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS autor (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL
      );
    ''');

    db.execute('''
    CREATE TABLE IF NOT EXISTS livro (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT NOT NULL,
    autor_nome TEXT NOT NULL,
    ano INTEGER,
    autor_id INTEGER,
    FOREIGN KEY (autor_id) REFERENCES autor(id) ON DELETE CASCADE
  );
  ''');
  }
}
