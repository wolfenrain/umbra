import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

class _MockFragmentProgram extends Mock implements FragmentProgram {}

class _MockShader extends Mock implements Shader {}

class TestWidget extends UmbraWidget {
  const TestWidget(this._program);

  final FragmentProgram _program;

  @override
  List<double> getFloatUniforms() {
    return [];
  }

  @override
  List<ImageShader> getSamplerUniforms() {
    return [];
  }

  @override
  Future<FragmentProgram> program() {
    // TODO: implement program
    throw UnimplementedError();
  }
}

void main() {
  group('UmbraWidget', () {
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
      expect(TestWidget(program), isNotNull);
    });
  });
}
