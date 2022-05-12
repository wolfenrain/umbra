import 'dart:io';

import 'package:mason/mason.dart' hide packageVersion;
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:umbra_cli/src/cmd/cmd.dart';
import 'package:umbra_cli/src/commands/commands.dart';
import 'package:umbra_cli/src/platform.dart';
import 'package:umbra_cli/src/workers/workers.dart';

import '../../helpers/set_up_testing_environment.dart';
import '../../helpers/test_command_runner.dart';

class MockPlatform extends Mock implements Platform {}

class MockLogger extends Mock implements Logger {}

class MockDownloader extends Mock implements Downloader {}

class MockFileExtractor extends Mock implements FileExtractor {}

class MockFileWriter extends Mock implements FileWriter {}

class MockCmd extends Mock implements Cmd {}

class MockProcessResult extends Mock implements ProcessResult {}

void main() {
  final cwd = Directory.current;

  group('umbra install-deps', () {
    late Logger logger;
    late TestCommandRunner commandRunner;
    late Downloader downloader;
    late FileExtractor extractor;
    late FileWriter writer;
    late Cmd cmd;
    late Platform platform;

    setUp(() {
      platform = MockPlatform();
      when(() => platform.isMacOS).thenReturn(false);
      when(() => platform.isLinux).thenReturn(false);
      when(() => platform.isWindows).thenReturn(false);
      when(() => platform.environment).thenReturn({});

      logger = MockLogger();
      when(() => logger.progress(any())).thenReturn(([String? _]) {});
      downloader = MockDownloader();
      extractor = MockFileExtractor();
      writer = MockFileWriter();
      cmd = MockCmd();

      commandRunner = TestCommandRunner([
        InstallDepsCommand(
          logger: logger,
          downloader: downloader,
          extractor: extractor,
          writer: writer,
          cmd: cmd,
          platform: platform,
        ),
      ]);
    });

    test('skip downloading if already installed', () async {
      when(() => platform.isMacOS).thenReturn(true);
      when(() => platform.environment).thenReturn({'HOME': cwd.path});

      final dataDirectory = Directory.fromUri(cwd.uri.resolve('.umbra'));
      File.fromUri(dataDirectory.uri.resolve('bin/glslc'))
          .createSync(recursive: true);

      final exitCode = await commandRunner.run(['install-deps']);
      expect(exitCode, equals(ExitCode.success.code));

      verify(() => logger.progress('Checking dependencies')).called(1);
      verifyNever(() => logger.progress('Downloading dependencies'));

      dataDirectory.deleteSync(recursive: true);
    });

    group('downloads and installs dependencies', () {
      final archiveFixturePath = testFixturesPath(cwd, suffix: 'archives');
      const expectedBytes = [116, 101, 115, 116, 10];

      late List<int> archiveBytes;

      setUp(() {
        archiveBytes =
            File(path.join(archiveFixturePath, 'test.tgz')).readAsBytesSync();

        when(() => downloader.download(any()))
            .thenAnswer((_) async => archiveBytes);
        when(() => extractor.extract(any(), any()))
            .thenAnswer((_) async => expectedBytes);
        when(() => writer.write(any(), any())).thenAnswer((_) async {});
        when(() => cmd.run(any(), any()))
            .thenAnswer((_) async => MockProcessResult());
      });

      test('on MacOS', () async {
        when(() => platform.isMacOS).thenReturn(true);
        when(() => platform.environment).thenReturn({'HOME': '/Users/test'});

        archiveBytes =
            File(path.join(archiveFixturePath, 'test.tgz')).readAsBytesSync();

        final exitCode = await commandRunner.run(['install-deps']);
        expect(exitCode, equals(ExitCode.success.code));

        verify(() => logger.progress('Checking dependencies')).called(1);

        verify(() => logger.progress('Downloading dependencies')).called(1);
        verify(
          () => downloader.download(
            'https://storage.googleapis.com/shaderc/artifacts/prod/graphics_shader_compiler/shaderc/macos/continuous_clang_release/388/20220202-124410/install.tgz',
          ),
        ).called(1);

        verify(() => logger.progress('Extracting dependencies')).called(1);
        verify(
          () => extractor.extract('install/bin/glslc', archiveBytes),
        ).called(1);
        verify(
          () => writer.write('/Users/test/.umbra/bin/glslc', expectedBytes),
        ).called(1);

        verify(() => cmd.run('chmod', ['+x', '/Users/test/.umbra/bin/glslc']))
            .called(1);
      });

      test('on Linux', () async {
        when(() => platform.isLinux).thenReturn(true);
        when(() => platform.environment).thenReturn({'HOME': '/home/test'});

        archiveBytes =
            File(path.join(archiveFixturePath, 'test.tgz')).readAsBytesSync();

        final exitCode = await commandRunner.run(['install-deps']);
        expect(exitCode, equals(ExitCode.success.code));

        verify(() => logger.progress('Checking dependencies')).called(1);

        verify(() => logger.progress('Downloading dependencies')).called(1);
        verify(
          () => downloader.download(
            'https://storage.googleapis.com/shaderc/artifacts/prod/graphics_shader_compiler/shaderc/linux/continuous_clang_release/380/20220202-124409/install.tgz',
          ),
        ).called(1);

        verify(() => logger.progress('Extracting dependencies')).called(1);
        verify(
          () => extractor.extract('install/bin/glslc', archiveBytes),
        ).called(1);
        verify(
          () => writer.write('/home/test/.umbra/bin/glslc', expectedBytes),
        ).called(1);
        verify(() => cmd.run('chmod', ['+x', '/home/test/.umbra/bin/glslc']))
            .called(1);
      });

      test('on Windows', () async {
        when(() => platform.isWindows).thenReturn(true);
        when(() => platform.environment).thenReturn(
          {'UserProfile': '/C/Users/test'},
        );

        archiveBytes =
            File(path.join(archiveFixturePath, 'test.zip')).readAsBytesSync();

        final exitCode = await commandRunner.run(['install-deps']);
        expect(exitCode, equals(ExitCode.success.code));

        verify(() => logger.progress('Checking dependencies')).called(1);

        verify(() => logger.progress('Downloading dependencies')).called(1);
        verify(
          () => downloader.download(
            'https://storage.googleapis.com/shaderc/artifacts/prod/graphics_shader_compiler/shaderc/windows/continuous_release_2017/384/20220202-124410/install.zip',
          ),
        ).called(1);

        verify(() => logger.progress('Extracting dependencies')).called(1);
        verify(
          () => extractor.extract('install/bin/glslc', archiveBytes),
        ).called(1);
        verify(
          () => writer.write('/C/Users/test/.umbra/bin/glslc', expectedBytes),
        ).called(1);
        verifyNever(() => cmd.run('chmod', any()));
      });
    });
  });
}
