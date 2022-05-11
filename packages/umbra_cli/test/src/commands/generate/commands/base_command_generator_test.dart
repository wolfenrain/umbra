// ignore_for_file: no_adjacent_strings_in_list

import 'dart:io';

import 'package:mason/mason.dart' hide packageVersion;
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:umbra_cli/src/commands/generate/commands/base_generate_command.dart';
import 'package:umbra_core/umbra_core.dart';

import '../../../../helpers/helpers.dart';

class MockLogger extends Mock implements Logger {}

class MockGenerator extends Mock implements Generator {}

class TestCommand extends BaseGenerateCommand {
  TestCommand({required GeneratorBuilder generator, Logger? logger})
      : super(generator: generator, logger: logger);

  @override
  String get description => 'test command';

  @override
  String get extension => 'test';

  @override
  String get name => 'test';
}

const expectedUsage = [
  'test command\n'
      '\n'
      'Usage: umbra generate test <input shader file>\n'
      '-h, --help      Print this usage information.\n'
      '-o, --output    The output directory for the generated files.\n'
      '\n'
      'Run "test help" to see global options.'
];

void main() {
  final cwd = Directory.current;

  group('BaseCommandGenerator', () {
    late Logger logger;
    late Generator generator;
    late TestCommandRunner commandRunner;

    setUp(() {
      logger = MockLogger();
      generator = MockGenerator();

      when(() => logger.progress(any())).thenReturn(([String? _]) {});

      commandRunner = TestCommandRunner(
        [TestCommand(generator: (_) => generator, logger: logger)],
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    group('--help', () {
      test(
        'outputs usage',
        overridePrint(() async {
          await commandRunner.run(['test', '--help']);
          expect(printLogs, equals(expectedUsage));

          printLogs.clear();

          await commandRunner.run(['test', '-h']);
          expect(printLogs, equals(expectedUsage));
        }),
      );
    });

    test('exits with code 66 when shader file input was not given', () async {
      final result = await commandRunner.run(['test']);
      expect(result, equals(ExitCode.noInput.code));
      verify(
        () => logger.err('No input shader file specified.'),
      ).called(1);
    });

    test('exits with code 66 when shader file input does not exist', () async {
      final result = await commandRunner.run(['test', 'fake-file']);
      expect(result, equals(ExitCode.noInput.code));
      verify(
        () => logger.err(
          'The shader file "fake-file" does not exist.',
        ),
      ).called(1);
    });

    test('outputs to stdout when - is given', () async {
      final fixturePath = path.join(testFixturesPath(cwd, suffix: 'raw'));
      final expected = File(path.join(fixturePath, 'input.glsl'));

      when(() => generator.generate()).thenAnswer(
        (_) async => expected.readAsBytesSync(),
      );

      final result = await commandRunner.run(
        ['test', path.join(fixturePath, 'input.glsl'), '--output', '-'],
      );
      expect(result, equals(ExitCode.success.code));
      verify(() => logger.info(expected.readAsStringSync())).called(1);
    });
  });
}
