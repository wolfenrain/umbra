// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:test/test.dart';
import 'package:umbra_core/umbra_core.dart';

import '../helpers/helpers.dart';

void main() {
  final cwd = Directory.current;

  group('Shader', () {
    test('can parse a shader', () {
      final shader = Shader.parse(simpleShader);

      expect(shader.version, equals(Version(320, 'es')));
      expect(
        shader.precision,
        equals(Precision(UniformType.float, PrecisionType.mediump)),
      );
      expect(shader.uniforms, isEmpty);

      expect(
        shader.toString(),
        matchesShaderFile(testFixturesPath(cwd, 'simple')),
      );
    });

    test('parses version correctly', () {
      final shader = Shader.parse(withVersionShader);

      expect(shader.version, equals(Version(300, 'es')));

      expect(
        shader.toString(),
        matchesShaderFile(testFixturesPath(cwd, 'with_version')),
      );
    });

    test('parses precision correctly', () {
      final shader = Shader.parse(withPrecisionShader);

      expect(
        shader.precision,
        equals(Precision(UniformType.float, PrecisionType.highp)),
      );

      expect(
        shader.toString(),
        matchesShaderFile(testFixturesPath(cwd, 'with_precision')),
      );
    });

    test('parses uniforms correctly', () {
      final shader = Shader.parse(withUniformsShader);

      expect(
        shader.uniforms,
        equals([
          Uniform('color', UniformType.vec4),
          Uniform('mix_value', UniformType.float),
        ]),
      );

      expect(
        shader.toString(),
        matchesShaderFile(testFixturesPath(cwd, 'simple')),
      );
    });
  });
}
