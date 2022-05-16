import 'dart:io';

import 'package:mason/mason.dart' hide packageVersion;
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:pub_updater/pub_updater.dart';
import 'package:test/test.dart';
import 'package:umbra_cli/src/cmd/cmd.dart';
import 'package:umbra_cli/src/umbra_command_runner.dart';
import 'package:umbra_cli/src/version.dart';

import '../../../../helpers/helpers.dart';

class _MockLogger extends Mock implements Logger {}

class _MockPubUpdater extends Mock implements PubUpdater {}

class _MockCmd extends Mock implements Cmd {}

// TODO(wolfen): as long as we can't use dart:ffi these tests are not really
// testing spirv generation.

void main() {
  final cwd = Directory.current;

  group('umbra generate spirv', () {
    late Logger logger;
    late PubUpdater pubUpdater;
    late Cmd cmd;
    late UmbraCommandRunner commandRunner;

    setUp(() {
      logger = _MockLogger();
      pubUpdater = _MockPubUpdater();
      cmd = _MockCmd();

      when(() => logger.progress(any())).thenReturn(([String? _]) {});
      when(
        () => pubUpdater.getLatestVersion(any()),
      ).thenAnswer((_) async => packageVersion);

      commandRunner = UmbraCommandRunner(
        logger: logger,
        pubUpdater: pubUpdater,
        cmd: cmd,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('exits with code 73 when the generator throws an exception', () async {
      final rawPath = path.join(testFixturesPath(cwd, suffix: 'raw'));
      Directory.current = rawPath;

      when(() => cmd.start(any(), any())).thenThrow(
        const ProcessException('', []),
      );

      final result = await commandRunner.run([
        'generate',
        'spirv',
        path.join(rawPath, 'output.glsl'),
      ]);

      expect(result, equals(ExitCode.cantCreate.code));
      verify(() => logger.progress(any())).called(2);
    });

    group('generate a SPIR-V binary file', () {
      final fixturePath = path.join(testFixturesPath(cwd, suffix: 'spirv'));
      final generatedPath = path.join(testFixturesPath(cwd, suffix: '.spirv'));
      final actual = File(path.join(generatedPath, 'input.spirv'));
      final expected = File(path.join(fixturePath, 'output.spirv'));

      setUp(() {
        when(() => cmd.start(any(), any())).thenAnswer((_) async {
          final args = _.positionalArguments[1] as List<String>;
          final outputFile = args[3];
          File(outputFile).writeAsBytesSync(expected.readAsBytesSync());

          return ProcessResult(
            0,
            0,
            Stream<List<int>>.fromIterable([]),
            Stream<List<int>>.fromIterable([]),
          );
        });
      });

      tearDown(() {
        final directory = Directory(generatedPath);
        if (directory.existsSync()) {
          directory.deleteSync(recursive: true);
        }
      });

      test('in the current directory', () async {
        setUpTestingEnvironment(cwd, suffix: '.spirv');
        Directory.current = generatedPath;

        final result = await commandRunner.run([
          'generate',
          'spirv',
          path.join(fixturePath, 'input.glsl'),
        ]);

        expect(result, equals(ExitCode.success.code));
        expect(filesEqual(actual, expected), isTrue);
        verify(() => logger.progress(any())).called(2);
      });

      test('in an existing output directory', () async {
        setUpTestingEnvironment(cwd, suffix: '.spirv');

        final result = await commandRunner.run([
          'generate',
          'spirv',
          path.join(fixturePath, 'input.glsl'),
          '--output',
          generatedPath,
        ]);

        expect(result, equals(ExitCode.success.code));
        expect(filesEqual(actual, expected), isTrue);
        verify(() => logger.progress(any())).called(2);
      });

      test('in an non-existing output directory', () async {
        final result = await commandRunner.run([
          'generate',
          'spirv',
          path.join(fixturePath, 'input.glsl'),
          '--output',
          generatedPath,
        ]);

        expect(result, equals(ExitCode.success.code));
        expect(filesEqual(actual, expected), isTrue);
        verify(() => logger.progress(any())).called(2);
      });

      group('with an existing file', () {
        setUp(() {
          setUpTestingEnvironment(cwd, suffix: '.spirv');
        });

        tearDown(() {
          tearDownTestingEnvironment(cwd, suffix: '.spirv');
        });

        test('and overwrite it', () async {
          actual.writeAsStringSync('It already exists');

          when(() => logger.confirm(any())).thenReturn(true);

          final result = await commandRunner.run([
            'generate',
            'spirv',
            path.join(fixturePath, 'input.glsl'),
            '--output',
            generatedPath,
          ]);

          expect(result, equals(ExitCode.success.code));
          expect(filesEqual(actual, expected), isTrue);
          verify(() => logger.progress(any())).called(2);
        });

        test('but abort it', () async {
          actual.writeAsStringSync('It already exists');

          when(() => logger.confirm(any())).thenReturn(false);

          final result = await commandRunner.run([
            'generate',
            'spirv',
            path.join(fixturePath, 'input.glsl'),
            '--output',
            generatedPath,
          ]);

          expect(result, equals(ExitCode.cantCreate.code));
          expect(filesEqual(actual, expected), isFalse);
          verify(() => logger.progress(any())).called(2);
        });
      });
    });
  });
}
