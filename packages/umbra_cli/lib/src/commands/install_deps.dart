import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart' hide packageVersion;
import 'package:umbra_cli/src/cmd/cmd.dart';
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
    Cmd? cmd,
  })  : _downloader = downloader ?? const Downloader(),
        _extractor = extractor ?? FileExtractor(),
        _writer = writer ?? const FileWriter(),
        super(logger: logger, cmd: cmd);

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

    final downloadingDone = logger.progress('Downloading dependencies');
    final archive = await _downloadingShaderC();
    downloadingDone('Dependencies downloaded');

    final extractingDone = logger.progress('Extracting dependencies');
    final fileBytes = await _extractor.extract('install/bin/glslc', archive);
    extractingDone('Dependencies extracted');

    final installingDone = logger.progress('Installing dependencies');
    await _writer.write(glslc.path, fileBytes);
    if (platform.isMacOS || platform.isLinux) {
      await cmd.run('chmod', ['+x', glslc.path]);
    }
    installingDone('Dependencies installed');

    return ExitCode.success.code;
  }

  /// We only check known platforms as this code can't be reached on
  /// unsupported platforms because of [dataDirectory].
  Future<List<int>> _downloadingShaderC() async {
    var shaderCDownloadLink = '';
    if (platform.isMacOS) {
      shaderCDownloadLink =
          'https://storage.googleapis.com/shaderc/artifacts/prod/graphics_shader_compiler/shaderc/macos/continuous_clang_release/388/20220202-124410/install.tgz';
    } else if (platform.isLinux) {
      shaderCDownloadLink =
          'https://storage.googleapis.com/shaderc/artifacts/prod/graphics_shader_compiler/shaderc/linux/continuous_clang_release/380/20220202-124409/install.tgz';
    } else if (platform.isWindows) {
      shaderCDownloadLink =
          'https://storage.googleapis.com/shaderc/artifacts/prod/graphics_shader_compiler/shaderc/windows/continuous_release_2017/384/20220202-124410/install.zip';
    }

    return _downloader.download(shaderCDownloadLink);
  }
}
