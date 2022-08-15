import 'package:test/test.dart';
import 'package:umbra/umbra.dart';

void main() {
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

    test('throws an exception when the uniform type is not supported', () {
      expect(
        () => UniformType.parse('fake'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
