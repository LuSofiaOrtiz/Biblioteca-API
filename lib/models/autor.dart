class Autor {
  final int? id;
  final String nome;

  Autor({this.id, required this.nome});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  factory Autor.fromMap(Map<String, dynamic> map) {
    return Autor(
      id: map['id'],
      nome: map['nome'],
    );
  }
}
