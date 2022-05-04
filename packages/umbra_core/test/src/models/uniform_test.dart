// ignore_for_file: prefer_const_constructors

import 'package:test/test.dart';
import 'package:umbra_core/umbra_core.dart';

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

    test('throws an exception when the uniform type is not supported', () {
      expect(
        () => Uniform.parse('name', 'fake'),
        throwsA(isA<Exception>()),
      );
    });

    test('toString', () {
      final uniform = Uniform('name', UniformType.float);

      expect(uniform.toString(), equals('uniform float name'));
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
