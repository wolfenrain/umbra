// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:umbra_core/umbra_core.dart';

import '../helpers/helpers.dart';

class MockFile extends Mock implements File {}

void main() {
  final cwd = Directory.current;

  group('Shader', () {
    test('can parse a shader from file', () {
      final file = MockFile();
      when(() => file.path).thenReturn('file/to/simple.glsl');
      when(file.readAsLinesSync).thenReturn(simpleShader.input);

      final shader = Shader.fromFile(file);

      expect(shader.name, 'simple');
      expect(shader.version, equals(Version(320, 'es')));
      expect(
        shader.precision,
        equals(Precision(UniformType.float, PrecisionType.mediump)),
      );
      expect(
        shader.uniforms,
        equals([Uniform('resolution', UniformType.vec2)]),
      );
    });

    test('can parse a shader', () {
      final shader = Shader.parse('simple', simpleShader.input);

      expect(shader.name, 'simple');
      expect(shader.version, equals(Version(320, 'es')));
      expect(
        shader.precision,
        equals(Precision(UniformType.float, PrecisionType.mediump)),
      );
      expect(
        shader.uniforms,
        equals([Uniform('resolution', UniformType.vec2)]),
      );
    });

    test('parses version correctly', () {
      final shader = Shader.parse('with_version', withVersionShader.input);

      expect(shader.version, equals(Version(300, 'es')));
    });

    test('parses precision correctly', () {
      final shader = Shader.parse('with_precision', withPrecisionShader.input);

      expect(
        shader.precision,
        equals(Precision(UniformType.float, PrecisionType.highp)),
      );
    });

    test('parses uniforms correctly', () {
      final shader = Shader.parse('with_uniform', withUniformsShader.input);

      expect(
        shader.uniforms,
        equals([
          Uniform('color', UniformType.vec4),
          Uniform('mix_value', UniformType.float),
          Uniform('resolution', UniformType.vec2),
        ]),
      );
    });
  });
}
