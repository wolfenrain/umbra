import 'package:flutter_test/flutter_test.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

class _MockTranspileException implements Exception {
  const _MockTranspileException(this.op, this.message);

  final int op;

  final String message;

  @override
  String toString() => '$op: $message';
}

void main() {
  group('UmbraException', () {
    test('rethrow the exception when the error is not convert-able', () {
      final exception = Exception('not a transpile one');

      expect(
        () => UmbraException(exception),
        throwsA(
          isA<Exception>()
              .having(
                (e) => e.toString(),
                'toString',
                equals('Exception: not a transpile one'),
              )
              .having((p0) => p0, 'equals', equals(exception)),
        ),
      );
    });
  });

  group('UnsupportedOperator', () {
    test(
      'creates an UnsupportedOperator when an operator is not supported',
      () {
        const exception = _MockTranspileException(128, 'Not a supported op.');

        final umbraException = UmbraException(exception);
        expect(umbraException, isA<UnsupportedOperator>());
        expect(umbraException.op, equals(128));
        expect(umbraException.description, equals('OpIAdd'));
      },
    );

    test('toString', () {
      const exception = _MockTranspileException(128, 'Not a supported op.');

      final umbraException = UmbraException(exception);
      expect(
        umbraException.toString(),
        equals(
          '''
Unsupported operator(128): OpIAdd

That means that there is an unsupported operator in the shader code.

For more information about this operator see https://www.khronos.org/registry/SPIR-V/specs/unified1/SPIRV.html#OpIAdd''',
        ),
      );
    });
  });
}
