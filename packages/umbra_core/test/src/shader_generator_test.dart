// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:test/test.dart';
import 'package:umbra_core/umbra_core.dart';

import '../helpers/helpers.dart';

void main() {
  final cwd = Directory.current;

  group('ShaderGenerator', () {
    test('generates a simple shader', () async {
      final shader = Shader.parse('simple', simpleShader.input);
      final generator = ShaderGenerator(shader);

      expect(
        await generator.generate(),
        matchesShaderFile(cwd, simpleShader),
      );
    });

    test('generates a shader with precision correctly', () async {
      final shader = Shader.parse('with_precision', withPrecisionShader.input);
      final generator = ShaderGenerator(shader);

      expect(
        await generator.generate(),
        matchesShaderFile(cwd, withPrecisionShader),
      );
    });

    test('generates a shader with uniforms correctly', () async {
      final shader = Shader.parse('with_uniforms', withUniformsShader.input);
      final generator = ShaderGenerator(shader);

      expect(
        await generator.generate(),
        matchesShaderFile(cwd, withUniformsShader),
      );
    });

    test('generates a shader with version correctly', () async {
      final shader = Shader.parse('with_version', withVersionShader.input);
      final generator = ShaderGenerator(shader);

      expect(
        await generator.generate(),
        matchesShaderFile(cwd, withVersionShader),
      );
    });
  });
}
