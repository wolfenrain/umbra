// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:test/test.dart';
import 'package:umbra_core/umbra_core.dart';

import '../../../helpers/helpers.dart';

void main() {
  final cwd = Directory.current;

  group('RawGenerator', () {
    test('generate a raw GLSL shader', () async {
      final specification = ShaderSpecification.parse(
        'simple',
        simpleShader.input,
      );
      final generator = RawGenerator(specification);

      expect(
        await generator.generate(),
        matchesShaderFile(cwd, simpleShader),
      );
    });

    test('generate a raw GLSL shader with precision correctly', () async {
      final specification = ShaderSpecification.parse(
        'with_precision',
        withPrecisionShader.input,
      );
      final generator = RawGenerator(specification);

      expect(
        await generator.generate(),
        matchesShaderFile(cwd, withPrecisionShader),
      );
    });

    test('generate a raw GLSL shader with uniforms correctly', () async {
      final specification = ShaderSpecification.parse(
        'with_uniforms',
        withUniformsShader.input,
      );
      final generator = RawGenerator(specification);

      expect(
        await generator.generate(),
        matchesShaderFile(cwd, withUniformsShader),
      );
    });

    test('generate a raw GLSL shader with version correctly', () async {
      final specification = ShaderSpecification.parse(
        'with_version',
        withVersionShader.input,
      );
      final generator = RawGenerator(specification);

      expect(
        await generator.generate(),
        matchesShaderFile(cwd, withVersionShader),
      );
    });
  });
}
