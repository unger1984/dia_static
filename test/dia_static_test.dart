import 'dart:io';

import 'package:dia/dia.dart';
import 'package:test/test.dart';

void main() {
  group('CORS test', () {
    App? dia;

    setUp(() {
      dia = App();

      dia?.listen('localhost', 8080);
    });

    tearDown(() async {
      dia?.close();
    });

    test('Access-Control-Allow-Origin', () async {
      final request = await HttpClient()
          .openUrl('OPTIONS', Uri.parse('http://localhost:8080'));
      final response = await request.close();
      expect(
          response.headers.value('access-control-allow-origin'), equals('*'));
    });
  });
}
