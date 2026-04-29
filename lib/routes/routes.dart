import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:biblioteca_api/repositories/autor_repository.dart';
import 'package:biblioteca_api/repositories/livro_repository.dart';
import 'package:biblioteca_api/models/autor.dart';
import 'package:biblioteca_api/models/livro.dart';

class AppRoutes {
  final _router = Router();
  final autorRepo = AutorRepository();
  final livroRepo = LivroRepository();

  AppRoutes() {
    _router.get('/autores', _getAutores);
    _router.post('/autores', _createAutor);
    _router.put('/autores/<id>', _updateAutor);
    _router.delete('/autores/<id>', _deleteAutor);
    _router.get('/livros/<id>', _getLivroById);
    _router.get('/livros', _getLivros);
    _router.post('/livros', _createLivro);
    _router.put('/livros/<id>', _updateLivro);
    _router.delete('/livros/<id>', _deleteLivro);

    _router.get('/autores/<id>/livros', _getLivrosPorAutor);
  }

  Router get router => _router;

  Response _jsonResponse(Object data, {int status = 200}) {
    return Response(
      status,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
  }

  int? _parseId(String id) {
    return int.tryParse(id);
  }

  Response _getAutores(Request req) {
    try {
      final autores = autorRepo.getAll();
      return _jsonResponse(autores.map((e) => e.toMap()).toList());
    } catch (e) {
      return _jsonResponse({'error': 'Erro ao buscar autores'}, status: 500);
    }
  }

  Future<Response> _createAutor(Request req) async {
    try {
      final body = jsonDecode(await req.readAsString());

      if (body['nome'] == null || body['nome'].toString().isEmpty) {
        return _jsonResponse({'error': 'Nome é obrigatório'}, status: 400);
      }

      final autor = Autor(nome: body['nome']);
      final created = autorRepo.create(autor);

      return _jsonResponse(created.toMap(), status: 201);
    } catch (e) {
      return _jsonResponse({'error': 'Erro ao criar autor'}, status: 500);
    }
  }

  Future<Response> _updateAutor(Request req, String id) async {
    try {
      final parsedId = _parseId(id);
      if (parsedId == null) {
        return _jsonResponse({'error': 'ID inválido'}, status: 400);
      }

      final body = jsonDecode(await req.readAsString());

      if (body['nome'] == null || body['nome'].toString().isEmpty) {
        return _jsonResponse({'error': 'Nome é obrigatório'}, status: 400);
      }

      autorRepo.update(parsedId, Autor(nome: body['nome']));

      return _jsonResponse({'message': 'Autor atualizado'});
    } catch (e) {
      return _jsonResponse({'error': 'Erro ao atualizar autor'}, status: 500);
    }
  }

  Response _deleteAutor(Request req, String id) {
    try {
      final parsedId = _parseId(id);
      if (parsedId == null) {
        return _jsonResponse({'error': 'ID inválido'}, status: 400);
      }

      autorRepo.delete(parsedId);

      return _jsonResponse({'message': 'Autor deletado'});
    } catch (e) {
      return _jsonResponse({'error': 'Erro ao deletar autor'}, status: 500);
    }
  }

  Response _getLivros(Request req) {
    try {
      final livros = livroRepo.getAll();
      return _jsonResponse(livros.map((e) => e.toMap()).toList());
    } catch (e) {
      return _jsonResponse({'error': 'Erro ao buscar livros'}, status: 500);
    }
  }

  Future<Response> _createLivro(Request req) async {
    try {
      final body = jsonDecode(await req.readAsString());

      if (body['titulo'] == null ||
          body['autor_nome'] == null ||
          body['ano'] == null ||
          body['autor_id'] == null) {
        return _jsonResponse({'error': 'Campos obrigatórios faltando'},
            status: 400);
      }
      if (!autorRepo.exists(body['autor_id'])) {
        return _jsonResponse({'error': 'Autor não encontrado'}, status: 400);
      }

      final livro = Livro(
        titulo: body['titulo'],
        autorNome: body['autor_nome'],
        ano: body['ano'],
        autorId: body['autor_id'],
      );

      livroRepo.create(livro);

      return _jsonResponse({'message': 'Livro criado'}, status: 201);
    } catch (e, stack) {
      print('Erro ao criar livro: $e');
      print(stack);

      return _jsonResponse(
        {'error': 'Erro interno no servidor'},
        status: 500,
      );
    }
  }

  Future<Response> _updateLivro(Request req, String id) async {
    try {
      final parsedId = _parseId(id);
      if (parsedId == null) {
        return _jsonResponse({'error': 'ID inválido'}, status: 400);
      }

      final body = jsonDecode(await req.readAsString());

      if (body['titulo'] == null ||
          body['autor_nome'] == null ||
          body['ano'] == null ||
          body['autor_id'] == null) {
        return _jsonResponse({'error': 'Campos obrigatórios faltando'},
            status: 400);
      }

      livroRepo.update(
        parsedId,
        Livro(
          titulo: body['titulo'],
          autorNome: body['autor_nome'],
          ano: body['ano'],
          autorId: body['autor_id'],
        ),
      );

      return _jsonResponse({'message': 'Livro atualizado'});
    } catch (e) {
      return _jsonResponse({'error': 'Erro ao atualizar livro'}, status: 500);
    }
  }

  Response _deleteLivro(Request req, String id) {
    try {
      final parsedId = _parseId(id);
      if (parsedId == null) {
        return _jsonResponse({'error': 'ID inválido'}, status: 400);
      }

      livroRepo.delete(parsedId);

      return _jsonResponse({'message': 'Livro deletado'});
    } catch (e) {
      return _jsonResponse({'error': 'Erro ao deletar livro'}, status: 500);
    }
  }

  Response _getLivrosPorAutor(Request req, String id) {
    try {
      final parsedId = _parseId(id);
      if (parsedId == null) {
        return _jsonResponse({'error': 'ID inválido'}, status: 400);
      }

      final livros = livroRepo.getByAutor(parsedId);

      return _jsonResponse(livros.map((e) => e.toMap()).toList());
    } catch (e) {
      return _jsonResponse(
        {'error': 'Erro ao buscar livros do autor'},
        status: 500,
      );
    }
  }
  Response _getLivroById(Request req, String id) {
  try {
    final parsedId = int.tryParse(id);

    if (parsedId == null) {
      return _jsonResponse({'error': 'ID inválido'}, status: 400);
    }

    final livro = livroRepo.getById(parsedId);

    if (livro == null) {
      return _jsonResponse({'error': 'Livro não encontrado'}, status: 404);
    }

    return _jsonResponse(livro.toMap());
  } catch (e, stack) {
    print('Erro ao buscar livro por ID: $e');
    print(stack);

    return _jsonResponse(
      {'error': 'Erro interno'},
      status: 500,
    );
  }
}
}
