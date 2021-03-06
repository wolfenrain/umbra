import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

class _MockFragmentProgram extends Mock implements FragmentProgram {}

class _MockShader extends Mock implements Shader {}

class TestShader extends UmbraShader {
  TestShader(super.program);
}

void main() {
  group('UmbraShader', () {
    late FragmentProgram program;
    late Shader shader;

    setUp(() {
      program = _MockFragmentProgram();
      shader = _MockShader();

      when(
        () => program.shader(
          floatUniforms: any(named: 'floatUniforms'),
          samplerUniforms: any(named: 'samplerUniforms'),
        ),
      ).thenReturn(shader);
    });

    test('can be instantiated', () {
      expect(TestShader(program), isNotNull);
    });

    test('has identity', () {
      expect(
        UmbraShader.identity,
        equals(
          Float64List.fromList([
            1.0, 0.0, 0.0, 0.0, //
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            0.0, 0.0, 0.0, 1.0,
          ]),
        ),
      );
    });
  });
}
