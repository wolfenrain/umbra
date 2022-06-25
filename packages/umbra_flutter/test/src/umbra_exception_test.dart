import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sky_engine/spirv/spirv.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

class _MockTranspileException extends Mock implements TranspileException {}

void main() {
  group('UmbraException', () {
    test(
      'throw an exception when the initial message is unknown',
      () {
        final exception = _MockTranspileException();
        when(() => exception.message).thenReturn('will fail');

        expect(
          () => UmbraException(exception),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'toString',
              equals(
                'Exception: Unknown transpiler exception message: will fail',
              ),
            ),
          ),
        );
      },
    );
  });

  group('UnsupportedOperator', () {
    test(
      'creates an UnsupportedOperator when an operator is not supported',
      () {
        final exception = _MockTranspileException();
        when(() => exception.message).thenReturn('Not a supported op.');
        when(() => exception.op).thenReturn(128);

        final umbraException = UmbraException(exception);
        expect(umbraException, isA<UnsupportedOperator>());
        expect(umbraException.op, equals(128));
        expect(umbraException.description, equals('OpIAdd'));
      },
    );

    test(
      'toString',
      () {
        final exception = _MockTranspileException();
        when(() => exception.message).thenReturn('Not a supported op.');
        when(() => exception.op).thenReturn(128);

        final umbraException = UmbraException(exception);
        expect(
          umbraException.toString(),
          equals('Unsupported operator(128): OpIAdd'),
        );
      },
    );
  });
}
