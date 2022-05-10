import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart' hide packageVersion;
import 'package:umbra_cli/src/umbra_command.dart';
import 'package:umbra_cli/src/workers/workers.dart';

/// {@template install_deps_command}
/// `umbra install-deps` command which install external dependencies for umbra.
/// {@endtemplate}
class InstallDepsCommand extends UmbraCommand {
  /// {@macro install_deps_command}
  InstallDepsCommand({
    Logger? logger,
    Downloader? downloader,
    FileExtractor? extractor,
    FileWriter? writer,
  })  : _downloader = downloader ?? const Downloader(),
        _extractor = extractor ?? const FileExtractor(),
        _writer = writer ?? const FileWriter(),
        super(logger: logger);

  @override
  final String description = 'Install external dependencies for umbra.';

  @override
  final String name = 'install-deps';

  final Downloader _downloader;

  final FileExtractor _extractor;

  final FileWriter _writer;

  @override
  Future<int> run() async {
    final checkingDependencies = logger.progress('Checking dependencies');
    final glslc = File.fromUri(dataDirectory.uri.resolve('bin/glslc'));
    if (glslc.existsSync()) {
      checkingDependencies('Dependencies are already installed');
      return ExitCode.success.code;
    }

    final String shaderCDownloadLink;
    if (Platform.isMacOS) {
      shaderCDownloadLink =
          'https://storage.googleapis.com/shaderc/artifacts/prod/graphics_shader_compiler/shaderc/macos/continuous_clang_release/388/20220202-124410/install.tgz';
    } else if (Platform.isLinux) {
      shaderCDownloadLink =
          'https://storage.googleapis.com/shaderc/badges/build_link_linux_clang_release.html';
    } else if (Platform.isWindows) {
      shaderCDownloadLink =
          'https://storage.googleapis.com/shaderc/badges/build_link_windows_vs2017_release.html';
    } else {
      throw UnsupportedError('Unsupported platform.');
    }

    final downloadingDone = logger.progress('Downloading dependencies');
    final archive = await _downloader.download(shaderCDownloadLink);
    downloadingDone('Dependencies downloaded');

    final extractingDone = logger.progress('Extracting dependencies');
    final fileBytes = await _extractor.extract('install/bin/glslc', archive);
    extractingDone('Dependencies extracted');

    final installingDone = logger.progress('Installing dependencies');
    await _writer.write(glslc, fileBytes);
    if (Platform.isMacOS || Platform.isLinux) {
      await Process.run('chmod', ['+x', glslc.path]);
    }
    installingDone('Dependencies installed');

    // ~/.umbra/bin/glslc --target-env=opengl -fshader-stage=fragment ./test/fixtures/raw/output.glsl -o -

    return ExitCode.success.code;
  }
}
