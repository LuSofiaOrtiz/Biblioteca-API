import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

import 'package:biblioteca_api/routes/routes.dart';
import 'package:biblioteca_api/middlewares/auth_middleware.dart';
import 'package:biblioteca_api/middlewares/log_middleware.dart';
import 'package:biblioteca_api/middlewares/cors_middleware.dart';

void main(List<String> args) async {
  final app = AppRoutes();

  final handler = Pipeline()
      .addMiddleware(logMiddleware())
      .addMiddleware(corsMiddleware())
      .addMiddleware(authMiddleware())
      .addHandler(app.router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final server = await io.serve(
    handler,
    InternetAddress.anyIPv4,
    port,
  );

  print('🚀 Servidor rodando em http://localhost:${server.port}');
}
