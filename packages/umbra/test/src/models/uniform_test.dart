// ignore_for_file: prefer_const_constructors

import 'package:test/test.dart';
import 'package:umbra/umbra.dart';

void main() {
  group('Uniform', () {
    test('can be instantiated', () {
      expect(
        () => Uniform('name', UniformType.float),
        returnsNormally,
      );
    });

    test('parsing', () {
      final uniform = Uniform.parse('name', 'float');

      expect(uniform.name, equals('name'));
      expect(uniform.type, equals(UniformType.float));
    });

    group('parses hints', () {
      test('correctly', () {
        final uniform = Uniform.parse('name', 'vec4', 'color');

        expect(uniform.hint, equals(UniformHint.parse('color')));
      });

      test('throws an exception if the type is not correct for the hint', () {
        expect(
          () => Uniform.parse('name', 'float', 'color'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              equals(
                'Exception: Given type float is not valid for given color',
              ),
            ),
          ),
        );
      });
    });

    group('supports uniforms', () {
      test('float', () {
        final uniform = Uniform.parse('name', 'float');

        expect(uniform.type, equals(UniformType.float));
      });

      test('vec2', () {
        final uniform = Uniform.parse('name', 'vec2');

        expect(uniform.type, equals(UniformType.vec2));
      });

      test('vec3', () {
        final uniform = Uniform.parse('name', 'vec3');

        expect(uniform.type, equals(UniformType.vec3));
      });

      test('vec4', () {
        final uniform = Uniform.parse('name', 'vec4');

        expect(uniform.type, equals(UniformType.vec4));
      });

      test('sampler2D', () {
        final uniform = Uniform.parse('name', 'sampler2D');

        expect(uniform.type, equals(UniformType.sampler2D));
      });
    });

    group('toString', () {
      test('without hints', () {
        final uniform = Uniform('name', UniformType.float);

        expect(uniform.toString(), equals('uniform float name'));
      });

      test('with hints', () {
        final uniform = Uniform(
          'name',
          UniformType.float,
          UniformHint.parse('color'),
        );

        expect(uniform.toString(), equals('uniform float name : hint_color'));
      });
    });
  });

  group('UniformType', () {
    group('has correct name', () {
      test('float', () {
        expect(UniformType.float.name, equals('float'));
      });

      test('vec2', () {
        expect(UniformType.vec2.name, equals('vec2'));
      });

      test('vec3', () {
        expect(UniformType.vec3.name, equals('vec3'));
      });

      test('vec4', () {
        expect(UniformType.vec4.name, equals('vec4'));
      });

      test('sampler2D', () {
        expect(UniformType.sampler2D.name, equals('sampler2D'));
      });
    });
  });
}
