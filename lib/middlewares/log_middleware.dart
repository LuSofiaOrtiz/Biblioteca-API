import 'package:shelf/shelf.dart';

Middleware logMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      print('[${DateTime.now()}] ${request.method} ${request.url}');
      final response = await innerHandler(request);
      return response;
    };
  };
}
