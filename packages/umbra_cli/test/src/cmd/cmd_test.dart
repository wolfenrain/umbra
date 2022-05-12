import 'dart:io';

import 'package:test/test.dart';
import 'package:umbra_cli/src/cmd/cmd.dart';

void main() {
  group('Cmd', () {
    group('.run', () {
      test('return result when succeeds', () async {
        final cmd = Cmd();
        final result = await cmd.run('echo', ['test']);

        expect(result, isA<ProcessResult>());
        expect(result.exitCode, equals(0));
        expect(result.stdout, equals('test\n'));
        expect(result.stderr, isEmpty);
      });

      test('throw exception when fails', () async {
        final cmd = Cmd();

        await expectLater(
          () => cmd.run('non-existing-command', ['test']),
          throwsA(
            isA<ProcessException>().having(
              (e) => e.errorCode,
              'errorCode',
              equals(127),
            ),
          ),
        );
      });
    });

    group('.start', () {
      test('return result when succeeds', () async {
        final cmd = Cmd();
        final result = await cmd.start('echo', ['test']);

        expect(result, isA<ProcessResult>());
        expect(result.exitCode, equals(0));
        expect(
          result.stdout,
          isA<Stream<List<int>>>().having(
            (e) => e.toList(),
            'data',
            completion(
              equals(<List<int>>[
                [116, 101, 115, 116, 10]
              ]),
            ),
          ),
        );
        expect(
          result.stderr,
          isA<Stream<List<int>>>()
              .having((e) => e.isEmpty, 'isEmpty', completion(isTrue)),
        );
      });

      test('throw exception when fails', () async {
        final cmd = Cmd();

        await expectLater(
          () => cmd.start('non-existing-command', ['test']),
          throwsA(
            isA<ProcessException>().having(
              (e) => e.errorCode,
              'errorCode',
              equals(127),
            ),
          ),
        );
      });
    });
  });
}
