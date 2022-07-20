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
    test('throw an exception when the initial message is unknown', () {
      const exception = _MockTranspileException(0, 'unexpected');

      expect(
        () => UmbraException(exception),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'toString',
            equals(
              'Exception: Unknown transpiler exception message: unexpected',
            ),
          ),
        ),
      );
    });

    test('throw an exception when the error is not a TranspileException', () {
      final exception = Exception('not a transpile one');

      expect(
        () => UmbraException(exception),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'toString',
            equals(
              '''Exception: Unsupported exception type: Exception: not a transpile one''',
            ),
          ),
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

For more information about this operator, see: https://www.khronos.org/registry/SPIR-V/specs/unified1/SPIRV.html#OpIAdd''',
        ),
      );
    });
  });
}
