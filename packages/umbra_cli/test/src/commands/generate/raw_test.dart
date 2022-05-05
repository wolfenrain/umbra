import 'dart:io';

import 'package:mason/mason.dart' hide packageVersion;
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:pub_updater/pub_updater.dart';
import 'package:test/test.dart';
import 'package:umbra_cli/src/umbra_command_runner.dart';
import 'package:umbra_cli/src/version.dart';

import '../../../helpers/helpers.dart';

class MockLogger extends Mock implements Logger {}

class MockPubUpdater extends Mock implements PubUpdater {}

void main() {
  final cwd = Directory.current;

  group('umbra generate raw', () {
    late Logger logger;
    late PubUpdater pubUpdater;
    late UmbraCommandRunner commandRunner;

    setUp(() {
      logger = MockLogger();
      pubUpdater = MockPubUpdater();

      when(() => logger.progress(any())).thenReturn(([String? _]) {});
      when(
        () => pubUpdater.getLatestVersion(any()),
      ).thenAnswer((_) async => packageVersion);

      commandRunner = UmbraCommandRunner(
        logger: logger,
        pubUpdater: pubUpdater,
      );
    });

    tearDown(() {
      Directory.current = cwd;
    });

    test('exits with code 64 when shader file input was not given', () async {
      final result = await commandRunner.run(['generate', 'raw']);
      expect(result, equals(ExitCode.usage.code));
      verify(
        () => logger.err('Expected path to a shader file.'),
      ).called(1);
    });

    test('exits with code 64 when shader file input does not exist', () async {
      final result = await commandRunner.run(['generate', 'raw', 'fake-file']);
      expect(result, equals(ExitCode.usage.code));
      verify(
        () => logger.err('The shader file "fake-file" does not exist.'),
      ).called(1);
    });

    group('generate a raw GLSL shader', () {
      final fixturePath = path.join(testFixturesPath(cwd, suffix: 'raw'));
      final generatedPath = path.join(testFixturesPath(cwd, suffix: '.raw'));
      final actual = File(path.join(generatedPath, 'input.glsl'));
      final expected = File(path.join(fixturePath, 'output.glsl'));

      tearDown(() {
        final directory = Directory(generatedPath);
        if (directory.existsSync()) {
          directory.deleteSync(recursive: true);
        }
      });

      test('in the current directory', () async {
        setUpTestingEnvironment(cwd, suffix: '.raw');
        Directory.current = generatedPath;

        final result = await commandRunner.run([
          'generate',
          'raw',
          path.join(fixturePath, 'input.glsl'),
        ]);

        expect(result, equals(ExitCode.success.code));
        expect(filesEqual(actual, expected), isTrue);
        verify(() => logger.progress(any())).called(2);
      });

      test('in an existing output directory', () async {
        setUpTestingEnvironment(cwd, suffix: '.raw');

        final result = await commandRunner.run([
          'generate',
          'raw',
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
          'raw',
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
          setUpTestingEnvironment(cwd, suffix: '.raw');
        });

        test('and overwrite it', () async {
          actual.writeAsStringSync('It already exists');

          when(() => logger.confirm(any())).thenReturn(true);

          final result = await commandRunner.run([
            'generate',
            'raw',
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
            'raw',
            path.join(fixturePath, 'input.glsl'),
            '--output',
            generatedPath,
          ]);

          expect(result, equals(ExitCode.cantCreate.code));
          expect(filesEqual(actual, expected), isFalse);
          verify(() => logger.progress(any())).called(1);
        });
      });
    });
  });
}
