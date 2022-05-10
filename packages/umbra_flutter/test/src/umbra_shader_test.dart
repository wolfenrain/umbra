import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

import '../helpers/image_data.dart';

class MockFragmentProgram extends Mock implements FragmentProgram {}

class MockShader extends Mock implements Shader {}

class TestShader extends UmbraShader {
  TestShader(
    FragmentProgram program, {
    required List<double> floatUniforms,
    required List<Image> samplers,
  }) : super(program, floatUniforms: floatUniforms, samplers: samplers);
}

void main() {
  group('UmbraShader', () {
    late FragmentProgram program;
    late Shader shader;

    setUp(() {
      program = MockFragmentProgram();
      shader = MockShader();

      when(
        () => program.shader(
          floatUniforms: any(named: 'floatUniforms'),
          samplerUniforms: any(named: 'samplerUniforms'),
        ),
      ).thenReturn(shader);
    });

    test('can be instantiated', () {
      expect(TestShader(program, floatUniforms: [], samplers: []), isNotNull);
    });

    group('can create a shader', () {
      test('with no uniforms', () {
        final testShader = TestShader(program, floatUniforms: [], samplers: []);

        expect(testShader.shader(const Size(1, 1)), same(shader));
        verify(
          () => program.shader(
            floatUniforms: Float32List.fromList([1, 1]),
            samplerUniforms: <ImageShader>[],
          ),
        ).called(1);
      });

      test('with a float uniforms', () async {
        final testShader = TestShader(
          program,
          floatUniforms: [2.0, 4.0, 8.0],
          samplers: [],
        );

        expect(testShader.shader(const Size(1, 1)), same(shader));
        verify(
          () => program.shader(
            floatUniforms: Float32List.fromList([2, 4, 8, 1, 1]),
            samplerUniforms: <ImageShader>[],
          ),
        ).called(1);
      });

      test('with a sampler2D uniform', () async {
        final image = await toImage(transparentImage);
        final testShader = TestShader(
          program,
          floatUniforms: [],
          samplers: [image],
        );

        expect(testShader.shader(const Size(1, 1)), same(shader));
        verify(
          () => program.shader(
            floatUniforms: Float32List.fromList([1, 1]),
            samplerUniforms: any(
              named: 'samplerUniforms',
              that: isA<List<ImageShader>>().having(
                (list) => list.length,
                'equals 1',
                equals(1),
              ),
            ),
          ),
        ).called(1);
      });
    });
  });
}
