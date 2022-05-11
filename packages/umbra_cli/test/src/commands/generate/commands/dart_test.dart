import 'dart:io';

import 'package:mason/mason.dart' hide packageVersion;
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:pub_updater/pub_updater.dart';
import 'package:test/test.dart';
import 'package:umbra_cli/src/umbra_command_runner.dart';
import 'package:umbra_cli/src/version.dart';

import '../../../../helpers/helpers.dart';

class MockLogger extends Mock implements Logger {}

class MockPubUpdater extends Mock implements PubUpdater {}

void main() {
  final cwd = Directory.current;

  group('umbra generate dart', () {
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

    group('generate a Dart Shader file', () {
      final fixturePath = path.join(testFixturesPath(cwd, suffix: 'dart'));
      final generatedPath = path.join(testFixturesPath(cwd, suffix: '.dart'));
      final actual = File(path.join(generatedPath, 'input.dart'));
      final expected = File(path.join(fixturePath, 'output.dart'));

      tearDown(() {
        final directory = Directory(generatedPath);
        if (directory.existsSync()) {
          directory.deleteSync(recursive: true);
        }
      });

      test('in the current directory', () async {
        setUpTestingEnvironment(cwd, suffix: '.dart');
        Directory.current = generatedPath;

        final result = await commandRunner.run([
          'generate',
          'dart',
          path.join(fixturePath, 'input.glsl'),
        ]);

        expect(result, equals(ExitCode.success.code));
        expect(filesEqual(actual, expected), isTrue);
        verify(() => logger.progress(any())).called(2);
      });

      test('in an existing output directory', () async {
        setUpTestingEnvironment(cwd, suffix: '.dart');

        final result = await commandRunner.run([
          'generate',
          'dart',
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
          'dart',
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
          setUpTestingEnvironment(cwd, suffix: '.dart');
        });

        test('and overwrite it', () async {
          actual.writeAsStringSync('It already exists');

          when(() => logger.confirm(any())).thenReturn(true);

          final result = await commandRunner.run([
            'generate',
            'dart',
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
            'dart',
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
