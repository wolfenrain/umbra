import 'dart:io';

import 'package:test/test.dart';
import 'package:umbra_cli/src/workers/workers.dart';

void main() {
  group('FileWriter', () {
    test('writes bytes to a file', () async {
      final file = File('.test_file');
      final bytes = [1, 2, 3];

      expect(file.existsSync(), isFalse);

      await const FileWriter().write(file.path, bytes);

      expect(file.existsSync(), isTrue);
      expect(file.readAsBytesSync(), equals(bytes));

      file.deleteSync();
    });
  });
}
