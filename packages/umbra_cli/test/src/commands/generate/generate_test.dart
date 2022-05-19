// ignore_for_file: no_adjacent_strings_in_list

import 'package:mason/mason.dart' hide packageVersion;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../helpers/helpers.dart';

const expectedUsage = [
  'Generate different file types for a shader file.\n'
      '\n'
      'Usage: umbra generate <subcommand> <shader_file>\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  dart    Generate a Dart Shader file.\n'
      '  raw     Generate a raw GLSL shader file.\n'
      '  spirv   Generate a SPIR-V binary file.\n'
      '\n'
      'Run "umbra help" to see global options.'
];

void main() {
  group('Generate', () {
    test(
      'throws UsageException when name is missing',
      withRunner((commandRunner, logger, platform, cmd, printLogs) async {
        const expectedErrorMessage = 'Missing subcommand for "umbra generate".';

        final result = await commandRunner.run(['generate']);
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'help',
      withRunner((commandRunner, logger, platform, cmd, printLogs) async {
        final result = await commandRunner.run(['generate', '--help']);
        expect(printLogs, equals(expectedUsage));
        expect(result, equals(ExitCode.success.code));

        printLogs.clear();

        final resultAbbr = await commandRunner.run(['generate', '-h']);
        expect(printLogs, equals(expectedUsage));
        expect(resultAbbr, equals(ExitCode.success.code));
      }),
    );
  });
}
