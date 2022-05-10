// ignore_for_file: no_adjacent_strings_in_list
import 'package:mason/mason.dart' hide packageVersion;
import 'package:mocktail/mocktail.dart';
import 'package:pub_updater/pub_updater.dart';
import 'package:test/test.dart';
import 'package:umbra_cli/src/umbra_command_runner.dart';
import 'package:umbra_cli/src/version.dart';

import '../../../helpers/helpers.dart';

class MockLogger extends Mock implements Logger {}

class MockPubUpdater extends Mock implements PubUpdater {}

const expectedUsage = [
  'Generate different file types for a shader file.\n'
      '\n'
      'Usage: umbra generate <subcommand> [arguments]\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Available subcommands:\n'
      '  dart   Generate a Dart Shader file.\n'
      '  raw    Generate a raw GLSL shader file.\n'
      '\n'
      'Run "umbra help" to see global options.'
];

void main() {
  group('Generate', () {
    late Logger logger;
    late PubUpdater pubUpdater;
    late UmbraCommandRunner commandRunner;

    setUp(() {
      printLogs = [];
      logger = MockLogger();
      pubUpdater = MockPubUpdater();

      when(
        () => pubUpdater.getLatestVersion(any()),
      ).thenAnswer((_) async => packageVersion);

      commandRunner = UmbraCommandRunner(
        logger: logger,
        pubUpdater: pubUpdater,
      );
    });

    group('run', () {
      // TODO(wolfen): Not working as expected
      // test(
      //   'handles no command',
      //   overridePrint(() async {
      //     final result = await commandRunner.run(['generate']);
      //     expect(printLogs, equals(expectedUsage));
      //     expect(result, equals(ExitCode.usage.code));
      //   }),
      // );

      group('--help', () {
        test(
          'outputs usage',
          overridePrint(() async {
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
    });
  });
}
