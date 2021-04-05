import 'package:dia/dia.dart';
import 'package:dia_static/dia_static.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('Static test', () {
    App? dia;

    setUp(() {
      dia = App();

      dia?.use(serve('./example'));
      dia?.use((ctx, next) async {
        ctx.body ??= 'error';
      });
      dia?.listen('localhost', 8080);
    });

    tearDown(() async {
      dia?.close();
    });

    test('Not found', () async {
      final response =
          await http.get(Uri.parse('http://localhost:8080/notfound.txt'));
      expect(response.body, equals('error'));
    });

    test('test.txt', () async {
      final response =
          await http.get(Uri.parse('http://localhost:8080/test.txt'));
      expect(response.statusCode, equals(200));
      expect(response.body, equals('test\n'));
    });
  });
}
