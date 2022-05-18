// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:umbra/umbra.dart';

import '../../helpers/helpers.dart';

class _MockFile extends Mock implements File {}

void main() {
  group('ShaderSpecification', () {
    test('can parse a shader from file', () {
      final file = _MockFile();
      when(() => file.path).thenReturn('file/to/simple.glsl');
      when(file.readAsLinesSync).thenReturn(simpleShader.input);
      when(file.existsSync).thenReturn(true);

      final specification = ShaderSpecification.fromFile(file);

      expect(specification.name, 'simple');
      expect(specification.version, equals(Version(320, 'es')));
      expect(
        specification.precision,
        equals(Precision(UniformType.float, PrecisionType.mediump)),
      );
      expect(
        specification.uniforms,
        equals([Uniform('resolution', UniformType.vec2)]),
      );
      verify(file.readAsLinesSync).called(1);
      verify(file.existsSync).called(1);
    });

    test('throws exception if file does not exist', () {
      final file = _MockFile();
      when(file.existsSync).thenReturn(false);
      when(() => file.path).thenReturn('file/to/simple.glsl');

      expect(() => ShaderSpecification.fromFile(file), throwsArgumentError);
      verify(file.existsSync).called(1);
    });

    test('can parse a shader', () {
      final specification = ShaderSpecification.parse(
        'simple',
        simpleShader.input,
      );

      expect(specification.name, 'simple');
      expect(specification.version, equals(Version(320, 'es')));
      expect(
        specification.precision,
        equals(Precision(UniformType.float, PrecisionType.mediump)),
      );
      expect(
        specification.uniforms,
        equals([Uniform('resolution', UniformType.vec2)]),
      );
    });

    test('parses version correctly', () {
      final specification = ShaderSpecification.parse(
        'with_version',
        withVersionShader.input,
      );

      expect(specification.version, equals(Version(300, 'es')));
    });

    test('parses precision correctly', () {
      final specification = ShaderSpecification.parse(
        'with_precision',
        withPrecisionShader.input,
      );

      expect(
        specification.precision,
        equals(Precision(UniformType.float, PrecisionType.highp)),
      );
    });

    test('parses uniforms correctly', () {
      final specification = ShaderSpecification.parse(
        'with_uniform',
        withUniformsShader.input,
      );

      expect(
        specification.uniforms,
        equals([
          Uniform('position', UniformType.vec2),
          Uniform('coordinates', UniformType.vec3),
          Uniform('color', UniformType.vec4),
          Uniform('mix_value', UniformType.float),
          Uniform('image', UniformType.sampler2D),
          Uniform('resolution', UniformType.vec2),
        ]),
      );
    });
  });
}
