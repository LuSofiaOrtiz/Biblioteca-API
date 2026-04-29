import 'package:shelf/shelf.dart';

Middleware authMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      // 🔥 LIBERA PREFLIGHT
      if (request.method == 'OPTIONS') {
        return Response.ok('');
      }

      final token = request.headers['Authorization'];

      if (token != 'Bearer 123456') {
        return Response.forbidden('Token inválido');
      }

      return await innerHandler(request);
    };
  };
}
