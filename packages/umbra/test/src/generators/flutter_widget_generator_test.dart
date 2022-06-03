// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:test/test.dart';
import 'package:umbra/umbra.dart';

import '../../helpers/helpers.dart';

void main() {
  final cwd = Directory.current;

  group('FlutterWidgetGenerator', () {
    test('generate a Flutter Widget file', () async {
      final specification = ShaderSpecification.parse(
        'simple',
        simpleShader.input,
      );
      final generator = FlutterWidgetGenerator(
        specification,
        spirvBytes: [1, 2, 3],
      );

      expect(
        await generator.generate(),
        matchesFixture(simpleShader.toFlutter(cwd)),
      );
    });

    test('generate a Flutter Widget file with uniforms correctly', () async {
      final specification = ShaderSpecification.parse(
        'with_uniforms',
        withUniformsShader.input,
      );
      final generator = FlutterWidgetGenerator(
        specification,
        spirvBytes: [1, 2, 3],
      );

      expect(
        await generator.generate(),
        matchesFixture(withUniformsShader.toFlutter(cwd)),
      );
    });
  });
}
