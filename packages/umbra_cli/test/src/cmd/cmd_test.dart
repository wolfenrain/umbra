import 'dart:io';

import 'package:test/test.dart';
import 'package:umbra_cli/src/cmd/cmd.dart';

void main() {
  group('Cmd', () {
    // test('return result when succeeds', () async {
    //   final cmd = Cmd();
    //   final result = await cmd.run('echo', ['test']);

    //   expect(result, isA<ProcessResult>());
    //   expect(result.exitCode, equals(0));
    //   expect(result.stdout, equals('test\n'));
    //   expect(result.stderr, isEmpty);
    // });

    test('throw exception when fails', () async {
      final cmd = Cmd();

      await expectLater(
        () => cmd.run('non-existing-command', ['test']),
        throwsA(
          isA<ProcessException>()
              .having((p0) => p0.errorCode, 'errorCode', equals(127))
              .having(
                (p0) => p0.message,
                'message',
                equals(
                  'Standard error\n/bin/sh: non-existing-command: command not found',
                ),
              ),
        ),
      );
    });
  });
}
