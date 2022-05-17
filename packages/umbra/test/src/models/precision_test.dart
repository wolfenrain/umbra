// ignore_for_file: prefer_const_constructors

import 'package:test/test.dart';
import 'package:umbra/umbra.dart';

void main() {
  group('Precision', () {
    test('can be instantiated', () {
      expect(
        () => Precision(UniformType.float, PrecisionType.mediump),
        returnsNormally,
      );
    });

    group('parsing', () {
      test('removes ; from line', () {
        final precision = Precision.parse('precision mediump float;');

        expect(precision.type, equals(UniformType.float));
        expect(precision.precision, equals(PrecisionType.mediump));
      });

      test('can be parsed', () {
        final precision = Precision.parse('precision mediump float');

        expect(precision.type, equals(UniformType.float));
        expect(precision.precision, equals(PrecisionType.mediump));
      });

      test('throws an exception when the precision is not supported', () {
        expect(
          () => Precision.parse('precision incorrect float;'),
          throwsA(isA<Exception>()),
        );
      });

      test('throws an exception when the uniform type is not supported', () {
        expect(
          () => Precision.parse('precision mediump vec2;'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('supports precisions', () {
      test('lowp', () {
        final precision = Precision.parse('precision lowp float;');

        expect(precision.precision, equals(PrecisionType.lowp));
      });

      test('mediump', () {
        final precision = Precision.parse('precision mediump float;');

        expect(precision.precision, equals(PrecisionType.mediump));
      });

      test('highp', () {
        final precision = Precision.parse('precision highp float;');

        expect(precision.precision, equals(PrecisionType.highp));
      });
    });

    test('toString', () {
      final precision = Precision(UniformType.float, PrecisionType.mediump);

      expect(precision.toString(), equals('precision mediump float'));
    });
  });

  group('PrecisionType', () {
    group('has correct name', () {
      test('lowp', () {
        expect(PrecisionType.lowp.name, equals('lowp'));
      });

      test('mediump', () {
        expect(PrecisionType.mediump.name, equals('mediump'));
      });

      test('highp', () {
        expect(PrecisionType.highp.name, equals('highp'));
      });
    });
  });
}
