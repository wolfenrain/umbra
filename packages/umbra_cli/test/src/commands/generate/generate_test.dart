import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:umbra_cli/src/cmd/cmd.dart';
import 'package:umbra_cli/src/commands/commands.dart';
import 'package:umbra_cli/src/commands/generate/targets/targets.dart';

import '../../../helpers/helpers.dart';

const expectedUsage = [
  // ignore: no_adjacent_strings_in_list
  'Generate files based on an Umbra Shader.\n'
      '\n'
      'Usage: umbra generate <shader_name>\n'
      '-h, --help                           Print this usage information.\n'
      '-o, --output=<directory>             The output directory for the '
      'created file(s).\n'
      '-t, --target=<target>                The target used for generation.\n'
      '\n'
      '          [dart-shader] (default)    Generate a Dart Shader.\n'
      '          [raw-shader]               Generate a raw GLSL shader.\n'
      '          [spirv]                    Generate a SPIR-R binary.\n'
      '\n'
      'Run "umbra help" to see global options.'
];

class _MockArgResults extends Mock implements ArgResults {}

class _MockLogger extends Mock implements Logger {}

class _FakeLogger extends Fake implements Logger {}

class _MockFile extends Mock implements File {}

class _MockDirectory extends Mock implements Directory {}

class _MockCmd extends Mock implements Cmd {}

class _MockProgress extends Mock implements Progress {}

void main() {
  final cwd = Directory.current;

  group('create', () {
    late List<String> progressLogs;
    late Logger logger;
    late Cmd cmd;

    setUpAll(() {
      registerFallbackValue(_FakeLogger());
    });

    setUp(() {
      progressLogs = <String>[];

      logger = _MockLogger();
      final progress = _MockProgress();
      when(() => progress.complete(any())).thenAnswer((_) {
        if (_.positionalArguments.isEmpty) {
          return;
        }
        if (_.positionalArguments[0] != null) {
          progressLogs.add(_.positionalArguments[0] as String);
        }
      });
      when(() => logger.progress(any())).thenReturn(progress);

      cmd = _MockCmd();
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
          [
            'generate',
            testFixturesPath(cwd, suffix: 'generate/input.glsl'),
            '--output',
            '/none/existing',
          ],
        );
        expect(result, equals(ExitCode.usage.code));
        verify(() => logger.err(expectedErrorMessage)).called(1);
      }),
    );

    dynamic Function() withIOOverride(
      Future<void> Function(File output) callback,
    ) {
      return () async {
        final inputFile = _MockFile();
        when(inputFile.existsSync).thenReturn(true);
        when(() => inputFile.path).thenReturn('test.raw');
        when(inputFile.readAsLinesSync).thenReturn([
          'vec4 fragment(vec2 uv, vec2 fragColor) {',
          '  return vec4(uv.x, uv.y, 1.0, 1.0);',
          '}',
        ]);

        final outputFile = _MockFile();
        final outputDirectory = _MockDirectory();
        when(outputFile.existsSync).thenReturn(false);
        when(() => outputFile.writeAsBytesSync(any())).thenReturn(null);
        when(() => outputDirectory.path).thenReturn('');
        when(outputDirectory.existsSync).thenReturn(true);

        final spirvInputFile = _MockFile();
        final spirvOutputFile = _MockFile();
        when(() => spirvInputFile.path).thenReturn('temp/created/raw.glsl');
        when(() => spirvOutputFile.path).thenReturn('temp/created/spirv');
        when(() => spirvInputFile.writeAsBytesSync(any())).thenReturn(null);
        when(spirvOutputFile.readAsBytesSync).thenReturn(
          Uint8List.fromList([3, 2, 1]),
        );
        when(() => cmd.start(any(), any())).thenAnswer((_) async {
          return ProcessResult(
            1,
            0,
            Stream<List<int>>.fromIterable([]),
            Stream<List<int>>.fromIterable([]),
          );
        });

        final dataDirectory = _MockDirectory();
        final tmpDirectory = _MockDirectory();
        final createdDirectory = _MockDirectory();

        when(() => dataDirectory.path).thenReturn('data');
        when(tmpDirectory.createTempSync).thenReturn(createdDirectory);
        when(() => tmpDirectory.path).thenReturn('temp');
        when(() => createdDirectory.path).thenReturn('temp/created');

        await IOOverrides.runZoned(
          () => callback(outputFile),
          createFile: (String path) {
            switch (path) {
              case 'test.raw':
                return inputFile;
              case 'test.dart':
              case 'test.glsl':
              case 'test.spirv':
                return outputFile;
              case 'temp/created/raw.glsl':
                return spirvInputFile;
              case 'temp/created/spirv':
                return spirvOutputFile;
            }
            throw UnimplementedError(path);
          },
          getSystemTempDirectory: () => tmpDirectory,
          createDirectory: (String path) {
            switch (path) {
              case '.umbra':
                return dataDirectory;
              default:
                return outputDirectory;
            }
          },
        );
      };
    }

    test(
      'completes successfully with correct output',
      withIOOverride((File output) async {
        final argResults = _MockArgResults();

        when(() => argResults.rest).thenReturn(['test']);
        when(() => argResults.rest).thenReturn(['test.raw']);
        final command = GenerateCommand(
          logger: logger,
          cmd: cmd,
        )..testArgResults = argResults;

        final result = await command.run();
        expect(result, equals(ExitCode.success.code));

        verify(() => logger.progress('Parsing shader file')).called(1);
        expect(progressLogs, contains('Shader file parsed'));
        verify(() => logger.progress('Generating')).called(1);
        expect(progressLogs, contains('Generated'));
        verifyNever(() => logger.confirm('Overwrite test.dart?'));
        verifyNever(() => logger.err('Aborting.'));

        verify(() => output.writeAsBytesSync(any())).called(1);

        verify(
          () => cmd.start('bin/glslc', [
            '--target-env=opengl',
            '-fshader-stage=fragment',
            '-o',
            'temp/created/spirv',
            'temp/created/raw.glsl',
          ]),
        ).called(1);
      }),
    );

    test(
      'prompts user when output file already exists',
      withIOOverride((output) async {
        final argResults = _MockArgResults();
        final command = GenerateCommand(
          logger: logger,
          cmd: cmd,
        )..testArgResults = argResults;

        when(output.existsSync).thenReturn(true);
        when(() => argResults.rest).thenReturn(['test.raw']);
        when(() => logger.confirm(any())).thenReturn(false);

        final result = await command.run();
        expect(result, equals(ExitCode.cantCreate.code));

        verify(() => logger.progress('Parsing shader file')).called(1);
        expect(progressLogs, contains('Shader file parsed'));
        verify(() => logger.progress('Generating')).called(1);
        expect(progressLogs, contains('Generated'));
        verify(
          () => logger.confirm('Overwrite test.dart?'),
        ).called(1);
        verify(() => logger.err('Aborting.')).called(1);

        verifyNever(() => output.writeAsBytesSync(any()));

        verify(
          () => cmd.start('bin/glslc', [
            '--target-env=opengl',
            '-fshader-stage=fragment',
            '-o',
            'temp/created/spirv',
            'temp/created/raw.glsl',
          ]),
        ).called(1);
      }),
    );

    group('--target', () {
      group('invalid target name', () {
        test(
          'invalid target name',
          withRunner((commandRunner, logger, platform, cmd, printLogs) async {
            const targetName = 'bad-target';
            const expectedErrorMessage =
                '''"$targetName" is not an allowed value for option "target".''';

            final result = await commandRunner.run(
              [
                'generate',
                testFixturesPath(cwd, suffix: 'generate/input.glsl'),
                '--target',
                targetName,
              ],
            );
            expect(result, equals(ExitCode.usage.code));
            verify(() => logger.err(expectedErrorMessage)).called(1);
          }),
        );
      });

      group('valid target names', () {
        Future<void> expectValidTargetName<T extends Target>({
          required String targetName,
          required File output,
        }) async {
          final argResults = _MockArgResults();
          final command = GenerateCommand(
            logger: logger,
            cmd: cmd,
          )..testArgResults = argResults;
          when(() => argResults['target'] as String?).thenReturn(targetName);
          when(() => argResults.rest).thenReturn(['test.raw']);

          final result = await command.run();
          expect(result, equals(ExitCode.success.code));

          verify(() => logger.progress('Parsing shader file')).called(1);
          expect(progressLogs, contains('Shader file parsed'));
          verify(() => logger.progress('Generating')).called(1);
          expect(progressLogs, contains('Generated'));

          verify(() => output.writeAsBytesSync(any())).called(1);
        }

        test(
          'dart-shader target',
          withIOOverride((File output) async {
            await expectValidTargetName<DartShaderTarget>(
              targetName: 'dart-shader',
              output: output,
            );

            verify(
              () => cmd.start('bin/glslc', [
                '--target-env=opengl',
                '-fshader-stage=fragment',
                '-o',
                'temp/created/spirv',
                'temp/created/raw.glsl',
              ]),
            ).called(1);
          }),
        );

        test(
          'raw-shader target',
          withIOOverride((File output) async {
            await expectValidTargetName<RawShaderTarget>(
              targetName: 'raw-shader',
              output: output,
            );

            verifyNever(
              () => cmd.start('bin/glslc', [
                '--target-env=opengl',
                '-fshader-stage=fragment',
                '-o',
                'temp/created/spirv',
                'temp/created/raw.glsl',
              ]),
            );
          }),
        );

        test(
          'spirv target',
          withIOOverride((File output) async {
            await expectValidTargetName<SpirvBinaryTarget>(
              targetName: 'spirv',
              output: output,
            );
            verify(
              () => cmd.start('bin/glslc', [
                '--target-env=opengl',
                '-fshader-stage=fragment',
                '-o',
                'temp/created/spirv',
                'temp/created/raw.glsl',
              ]),
            ).called(1);
          }),
        );
      });
    });
  });
}
