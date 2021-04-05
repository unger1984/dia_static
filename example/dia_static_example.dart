import 'package:dia/dia.dart';
import 'package:dia_static/dia_static.dart';

void main() {
  final app = App();

  app.use(serve('./example'));

  app.use((ctx, next) async {
    ctx.body ??= 'error';
  });

  /// Start server listen on localhsot:8080
  app
      .listen('localhost', 8080)
      .then((info) => print('Server started on http://localhost:8080'));
}
