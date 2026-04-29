import 'package:biblioteca_api/database.dart';
import 'package:biblioteca_api/models/livro.dart';

class LivroRepository {
  final db = DatabaseService().db;

  List<Livro> getAll() {
    final result = db.select('SELECT * FROM livro');
    return result.map((row) => Livro.fromMap(row)).toList();
  }

  List<Livro> getByAutor(int autorId) {
    final result = db.select(
      'SELECT * FROM livro WHERE autor_id = ?',
      [autorId],
    );
    return result.map((row) => Livro.fromMap(row)).toList();
  }
  Livro? getById(int id) {
  final result = db.select(
    'SELECT * FROM livro WHERE id = ?',
    [id],
  );

  if (result.isEmpty) return null;

  return Livro.fromMap(result.first);
}
  void create(Livro livro) {
    db.execute('''
      INSERT INTO livro (titulo, autor_nome, ano, autor_id)
      VALUES (?, ?, ?, ?)
    ''', [livro.titulo, livro.autorNome, livro.ano, livro.autorId]);
  }

  void update(int id, Livro livro) {
    db.execute('''
      UPDATE livro
      SET titulo = ?, autor_nome = ?, ano = ?, autor_id = ?
      WHERE id = ?
    ''', [livro.titulo, livro.autorNome, livro.ano, livro.autorId, id]);
  }

  void delete(int id) {
    db.execute('DELETE FROM livro WHERE id = ?', [id]);
  }
}
