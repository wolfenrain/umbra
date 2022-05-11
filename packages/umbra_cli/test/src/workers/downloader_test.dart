import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';
import 'package:umbra_cli/src/workers/workers.dart';

void main() {
  group('Downloader', () {
    late HttpServer server;
    late StreamSubscription<HttpRequest> subscription;

    setUp(() async {
      server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
      subscription = server.listen((request) {
        request.response.write('test');
        request.response.close();
      });
    });

    tearDown(() async {
      await subscription.cancel();
      await server.close();
    });

    test('writes bytes to a file', () async {
      final result = await const Downloader().download('http://localhost:8080');

      expect(result, equals([116, 101, 115, 116]));
    });
  });
}
