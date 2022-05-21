import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:umbra/umbra.dart';
import 'package:umbra_cli/src/commands/commands.dart';
import 'package:umbra_cli/src/generators/spirv_generator.dart';

import '../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Generate files based on an Umbra Shader.\n'
      '\n'
      'Usage: umbra generate <shader_name>\n'
      '-h, --help                           Print this usage information.\n'
      '-o, --output=<directory>             The output directory for the created file(s).\n'
      '-t, --target=<target>                The target used for generation.\n'
      '\n'
      '          [dart-shader] (default)    Generate a Dart Shader.\n'
      '          [raw-shader]               Generate a raw GLSL shader.\n'
      '          [spirv]                    Generate a Dart Shader.\n'
      '\n'
      'Run "umbra help" to see global options.'
];

class _MockArgResults extends Mock implements ArgResults {}

class _MockLogger extends Mock implements Logger {}

class _MockGenerator extends Mock implements Generator {}

class _FakeLogger extends Fake implements Logger {}

class _MockFile extends Mock implements File {}

class _MockDirectory extends Mock implements Directory {}

void main() {
  final cwd = Directory.current;

  group('create', () {
    late List<String> progressLogs;
    late Logger logger;
    late File shaderFile;

    setUpAll(() {
      registerFallbackValue(_FakeLogger());
    });

    setUp(() {
      progressLogs = <String>[];

      logger = _MockLogger();
      when(() => logger.progress(any())).thenReturn(
        ([_]) {
          if (_ != null) progressLogs.add(_);
        },
      );
      shaderFile = File(testFixturesPath(cwd, suffix: 'generate/input.glsl'));
    });

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

    test(
      'throws UsageException when file is missing',
      withRunner((commandRunner, logger, platform, cmd, printLogs) async {
        const expectedErrorMessage = 'No file specified.';

        final result = await commandRunner.run(['generate', '']);
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when file does not exist',
      withRunner((commandRunner, logger, platform, cmd, printLogs) async {
        const expectedErrorMessage = 'File "test.glsl" does not exist.';

        final result = await commandRunner.run(['generate', 'test.glsl']);
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test(
      'throws UsageException when output directory does not exist',
      withRunner((commandRunner, logger, platform, cmd, printLogs) async {
        const expectedErrorMessage =
            'Directory "/none/existing" does not exist.';

        final result = await commandRunner.run(
          ['generate', shaderFile.path, '--output', '/none/existing'],
        );
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    test('completes successfully with correct output', () async {
      final argResults = _MockArgResults();
      final generator = _MockGenerator();
      final shaderFile = _MockFile();
      final outputFile = _MockFile();
      final outputDirectory = _MockDirectory();
      final command = GenerateCommand(
        logger: logger,
        generatorPasser: (_) => generator,
        fileOpener: (String path) {
          return (path == 'test.raw') ? shaderFile : outputFile;
        },
        directoryOpener: (String path) => outputDirectory,
      )..testArgResults = argResults;
      when(() => argResults.rest).thenReturn(['test']);
      when(() => argResults.rest).thenReturn(['test.raw']);
      when(() => shaderFile.path).thenReturn('test.raw');
      when(shaderFile.existsSync).thenReturn(true);
      when(shaderFile.readAsLinesSync).thenReturn([
        'vec4 fragment(in vec2 uv, in vec2 fragCoord) {',
        '  return vec4(1.0);',
        '}',
      ]);
      when(outputFile.existsSync).thenReturn(false);
      when(() => outputFile.writeAsBytesSync(any())).thenReturn(null);
      when(() => outputDirectory.path).thenReturn('');
      when(outputDirectory.existsSync).thenReturn(true);
      when(generator.generate).thenAnswer((_) async => <int>[1, 2, 3]);

      final result = await command.run();
      expect(result, equals(ExitCode.success.code));

      verify(() => logger.progress('Parsing shader file')).called(1);
      expect(progressLogs, contains('Shader file parsed'));
      verify(() => logger.progress('Generating')).called(1);
      expect(progressLogs, contains('Generated'));

      verify(generator.generate).called(1);
      verify(() => outputFile.writeAsBytesSync(any())).called(1);
    });

    test('prompts user when output file already exists', () async {
      final argResults = _MockArgResults();
      final generator = _MockGenerator();
      final shaderFile = _MockFile();
      final outputFile = _MockFile();
      final outputDirectory = _MockDirectory();
      final command = GenerateCommand(
        logger: logger,
        generatorPasser: (_) => generator,
        fileOpener: (String path) {
          return (path == 'test.raw') ? shaderFile : outputFile;
        },
        directoryOpener: (String path) => outputDirectory,
      )..testArgResults = argResults;
      when(() => argResults.rest).thenReturn(['test']);
      when(() => argResults.rest).thenReturn(['test.raw']);
      when(() => shaderFile.path).thenReturn('test.raw');
      when(shaderFile.existsSync).thenReturn(true);
      when(shaderFile.readAsLinesSync).thenReturn([
        'vec4 fragment(in vec2 uv, in vec2 fragCoord) {',
        '  return vec4(1.0);',
        '}',
      ]);
      when(outputFile.existsSync).thenReturn(true);
      when(() => outputFile.writeAsBytesSync(any())).thenReturn(null);
      when(() => outputDirectory.path).thenReturn('');
      when(outputDirectory.existsSync).thenReturn(true);
      when(generator.generate).thenAnswer((_) async => <int>[1, 2, 3]);
      when(() => logger.confirm(any())).thenReturn(false);

      final result = await command.run();
      expect(result, equals(ExitCode.cantCreate.code));

      verify(() => logger.progress('Parsing shader file')).called(1);
      expect(progressLogs, contains('Shader file parsed'));
      verify(() => logger.progress('Generating')).called(1);
      expect(progressLogs, contains('Generated'));
      verify(() => logger.err('Aborting.')).called(1);

      verify(generator.generate).called(1);
      verifyNever(() => outputFile.writeAsBytesSync(any()));
    });

    group('--target', () {
      group('invalid target name', () {
        test(
          'invalid target name',
          withRunner((commandRunner, logger, platform, cmd, printLogs) async {
            const targetName = 'bad-target';
            const expectedErrorMessage =
                '''"$targetName" is not an allowed value for option "target".''';

            final result = await commandRunner.run(
              ['generate', shaderFile.path, '--target', targetName],
            );
            expect(result, equals(ExitCode.usage.code));
            verify(() => logger.err(expectedErrorMessage)).called(1);
          }),
        );
      });

      group('valid target names', () {
        Future<void> expectValidTargetName<T extends Generator>({
          required String targetName,
        }) async {
          final argResults = _MockArgResults();
          final generator = _MockGenerator();
          final shaderFile = _MockFile();
          final outputFile = _MockFile();
          final outputDirectory = _MockDirectory();
          final command = GenerateCommand(
            logger: logger,
            generatorPasser: (receivedGenerator) {
              expect(receivedGenerator, isA<T>());
              return generator;
            },
            fileOpener: (String path) {
              return (path == 'test.raw') ? shaderFile : outputFile;
            },
            directoryOpener: (String path) => outputDirectory,
          )..testArgResults = argResults;
          when(() => argResults['target'] as String?).thenReturn(targetName);
          when(() => argResults.rest).thenReturn(['test.raw']);
          when(() => shaderFile.path).thenReturn('test.raw');
          when(shaderFile.existsSync).thenReturn(true);
          when(shaderFile.readAsLinesSync).thenReturn([
            'vec4 fragment(in vec2 uv, in vec2 fragCoord) {',
            '  return vec4(1.0);',
            '}',
          ]);
          when(outputFile.existsSync).thenReturn(false);
          when(() => outputFile.writeAsBytesSync(any())).thenReturn(null);
          when(() => outputDirectory.path).thenReturn('');
          when(outputDirectory.existsSync).thenReturn(true);
          when(generator.generate).thenAnswer((_) async {
            return <int>[1, 2, 3];
          });

          final result = await command.run();
          expect(result, equals(ExitCode.success.code));

          verify(() => logger.progress('Parsing shader file')).called(1);
          expect(progressLogs, contains('Shader file parsed'));
          verify(() => logger.progress('Generating')).called(1);
          expect(progressLogs, contains('Generated'));

          verify(generator.generate).called(1);
          verify(() => outputFile.writeAsBytesSync(any())).called(1);
        }

        test('dart-shader target', () async {
          await expectValidTargetName<DartGenerator>(
            targetName: 'dart-shader',
          );
        });

        test('raw-shader target', () async {
          await expectValidTargetName<RawGenerator>(
            targetName: 'raw-shader',
          );
        });

        test('spirv target', () async {
          await expectValidTargetName<SpirvGenerator>(
            targetName: 'spirv',
          );
        });
      });
    });
  });

  test('proxies', () {
    final generator = _MockGenerator();
    expect(proxies(generator), equals(generator));
  });
}
