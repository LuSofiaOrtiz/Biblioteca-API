class Livro {
  final int? id;
  final String titulo;
  final String autorNome;
  final int ano;
  final int autorId;

  Livro({
    this.id,
    required this.titulo,
    required this.autorNome,
    required this.ano,
    required this.autorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'autor_nome': autorNome,
      'ano': ano,
      'autor_id': autorId,
    };
  }

  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      id: map['id'],
      titulo: map['titulo'],
      autorNome: map['autor_nome'],
      ano: map['ano'],
      autorId: map['autor_id'],
    );
  }
}
