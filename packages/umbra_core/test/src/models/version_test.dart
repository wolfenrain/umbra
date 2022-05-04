// ignore_for_file: prefer_const_constructors

import 'package:test/test.dart';
import 'package:umbra_core/umbra_core.dart';

void main() {
  group('Version', () {
    test('can be instantiated', () {
      expect(
        () => Version(320, 'es'),
        returnsNormally,
      );
    });

    group('parsing', () {
      test('can be parsed', () {
        final precision = Version.parse('#version 320 es');

        expect(precision.version, equals(320));
        expect(precision.language, equals('es'));
      });
    });

    test('toString', () {
      final version = Version(320, 'es');

      expect(version.toString(), equals('#version 320 es'));
    });
  });
}
