// ignore_for_file: no_adjacent_strings_in_list

import 'dart:io';

import 'package:mason/mason.dart' hide packageVersion;
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:umbra/umbra.dart';
import 'package:umbra_cli/src/commands/generate/commands/base_generate_command.dart';
import 'package:umbra_cli/src/exit_with.dart';

import '../../../../helpers/helpers.dart';

class _MockLogger extends Mock implements Logger {}

class _MockGenerator extends Mock implements Generator {}

class TestCommand extends BaseGenerateCommand {
  TestCommand({required this.generator, Logger? logger})
      : super(logger: logger);

  Generator Function(ShaderSpecification) generator;

  @override
  String get description => 'test command';

  @override
  String get extension => 'test';

  @override
  String get name => 'test';

  @override
  Future<List<int>> generate(ShaderSpecification specification) {
    return generator(specification).generate();
  }
}

const expectedUsage = [
  'test command\n'
      '\n'
      'Usage: test test <shader_file>\n'
      '-h, --help                  Print this usage information.\n'
      '-o, --output=<directory>    The output directory for the generated files.\n'
      '                            If "-" is given it will be written to stdout\n'
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
      logger = _MockLogger();
      generator = _MockGenerator();

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
        overridePrint((printLogs) async {
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

    test('exits with code 73 when the generator throws an exception', () async {
      final fixturePath = path.join(testFixturesPath(cwd, suffix: 'raw'));
      when(() => generator.generate()).thenThrow(
        ExitWith(ExitCode.cantCreate, 'fail'),
      );

      final result = await commandRunner.run([
        'test',
        path.join(fixturePath, 'input.glsl'),
      ]);

      expect(result, equals(ExitCode.cantCreate.code));
      verify(() => logger.err('fail')).called(1);
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
