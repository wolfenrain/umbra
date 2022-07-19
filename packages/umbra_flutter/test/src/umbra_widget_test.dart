import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

class _MockFragmentProgram extends Mock implements FragmentProgram {}

class _MockShader extends Mock implements Shader {}

class TranspileException implements Exception {
  @override
  String toString() => '128: Not a supported op.';
}

class TestWidget extends UmbraWidget {
  const TestWidget(
    this._program, {
    super.key,
    super.errorBuilder,
    super.compilingBuilder,
    super.child,
  });

  final Future<FragmentProgram>? _program;

  @override
  List<double> getFloatUniforms() {
    return [];
  }

  @override
  List<ImageShader> getSamplerUniforms() {
    return [];
  }

  @override
  Future<FragmentProgram> program() async {
    if (_program == null) {
      throw Exception('TestWidget._program is null');
    }
    return _program!;
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
      expect(TestWidget(Future.value(program)), isNotNull);
    });

    testWidgets('render shader correctly inside a widget', (tester) async {
      // We use a RadialGradient to ensure that the widget is actually
      // rendering something because we don't want to test the FragmentShader
      // itself.
      when(
        () => program.shader(
          floatUniforms: any(named: 'floatUniforms'),
          samplerUniforms: any(named: 'samplerUniforms'),
        ),
      ).thenAnswer((_) {
        final uniforms = _.namedArguments[#floatUniforms] as List<double>;
        return const RadialGradient(colors: [Colors.red, Colors.blue])
            .createShader(
          Rect.fromLTWH(
            0,
            0,
            uniforms[uniforms.length - 2],
            uniforms[uniforms.length - 1],
          ),
        );
      });

      await tester.pumpWidget(TestWidget(Future.value(program)));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(TestWidget),
        matchesGoldenFile('goldens/umbra_widget_test.png'),
      );

      verify(
        () => program.shader(
          floatUniforms: any(named: 'floatUniforms', that: equals([800, 600])),
          samplerUniforms: any(named: 'samplerUniforms'),
        ),
      ).called(1);
    });

    group('on error', () {
      testWidgets(
        'show the error widget if no error builder is given',
        (tester) async {
          await tester.pumpWidget(const TestWidget(null));
          await tester.pumpAndSettle();

          expect(find.byType(ErrorWidget), findsOneWidget);
        },
      );

      testWidgets(
        'convert TranspileException to UmbraException',
        (tester) async {
          await tester.pumpWidget(
            TestWidget(
              Future.error(TranspileException()),
              errorBuilder: (context, error, stackTrace) {
                expect(error, isA<UmbraException>());
                return Container(key: const Key('Error'));
              },
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byKey(const Key('Error')), findsOneWidget);
        },
      );

      testWidgets(
        'call the error builder',
        (tester) async {
          await tester.pumpWidget(
            TestWidget(
              null,
              errorBuilder: (context, error, stackTrace) => Container(
                key: const Key('Error'),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byKey(const Key('Error')), findsOneWidget);
        },
      );
    });

    group('on no data', () {
      testWidgets(
        'shows nothing if child is not given',
        (tester) async {
          await tester.pumpWidget(
            TestWidget(Future<FragmentProgram>.value(program)),
          );

          expect(find.byType(SizedBox), findsOneWidget);
        },
      );

      testWidgets(
        'shows child',
        (tester) async {
          await tester.pumpWidget(
            TestWidget(
              Future<FragmentProgram>.value(program),
              child: Container(key: const Key('Child')),
            ),
          );

          expect(find.byKey(const Key('Child')), findsOneWidget);
        },
      );

      testWidgets(
        'calls compiling builder',
        (tester) async {
          await tester.pumpWidget(
            TestWidget(
              Future<FragmentProgram>.value(program),
              compilingBuilder: (context, child) {
                return Container(key: const Key('Compiling'));
              },
            ),
          );

          expect(find.byKey(const Key('Compiling')), findsOneWidget);
        },
      );
    });
  });
}
