import 'package:biblioteca_api/database.dart';
import 'package:biblioteca_api/models/autor.dart';

class AutorRepository {
  final db = DatabaseService().db;

  List<Autor> getAll() {
    final result = db.select('SELECT * FROM autor');
    return result.map((row) => Autor.fromMap(row)).toList();
  }

  Autor create(Autor autor) {
    final stmt = db.prepare('INSERT INTO autor (nome) VALUES (?)');
    stmt.execute([autor.nome]);
    stmt.dispose();

    final result = db.select('SELECT last_insert_rowid() as id');
    final id = result.first['id'] as int;

    return Autor(id: id, nome: autor.nome);
  }

  bool exists(int id) {
    final result = db.select(
      'SELECT 1 FROM autor WHERE id = ? LIMIT 1',
      [id],
    );
    return result.isNotEmpty;
  }

  void update(int id, Autor autor) {
    db.execute(
      'UPDATE autor SET nome = ? WHERE id = ?',
      [autor.nome, id],
    );
  }

  void delete(int id) {
    db.execute('DELETE FROM autor WHERE id = ?', [id]);
  }
}
