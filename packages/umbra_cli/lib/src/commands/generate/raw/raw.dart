import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart' hide packageVersion;
import 'package:path/path.dart' as path;
import 'package:umbra_cli/src/umbra_command.dart';
import 'package:umbra_core/umbra_core.dart';

/// {@template raw_command}
/// Generate a raw GLSL shader file based on the given shader file.
/// {@endtemplate}
class RawCommand extends UmbraCommand {
  /// {@macro raw_command}
  RawCommand({
    Logger? logger,
  }) : super(logger: logger) {
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'The output directory for the generated files.',
    );
  }

  @override
  String get description => 'Generate a raw GLSL shader file.';

  @override
  String get name => 'raw';

  @override
  String get invocation => 'umbra generate raw <input shader file>';

  @override
  Future<int> run() async {
    final readingShaderDone = logger.progress('Parsing shader file');
    final shaderSpecification = _shaderSpecification;
    final outputDirectory = _outputDirectory;
    readingShaderDone('Shader file parsed');

    final outputFile = File(
      path.join(outputDirectory.path, '${shaderSpecification.name}.glsl'),
    );
    if (outputFile.existsSync()) {
      final answer = logger.confirm(
        '  ${yellow.wrap('Overwrite "${outputFile.path}"?')}',
      );
      if (!answer) {
        logger.err('Aborting.');
        return ExitCode.cantCreate.code;
      }
    }
    final generateDone = logger.progress('Generating "${outputFile.path}"');

    final generator = ShaderGenerator(shaderSpecification);
    final result = await generator.generate();
    await outputFile.writeAsString(result);

    generateDone('Generated "${outputFile.path}"');

    return ExitCode.success.code;
  }

  /// Gets the shader specification.
  ShaderSpecification get _shaderSpecification {
    final rest = results.rest;
    if (rest.isEmpty) {
      throw UsageException('Expected path to a shader file.', invocation);
    }
    try {
      return ShaderSpecification.fromFile(File(rest.first));
    } catch (err) {
      throw UsageException(
        (err as ArgumentError).message as String,
        invocation,
      );
    }
  }

  /// Gets the output directory.
  Directory get _outputDirectory {
    if (results['output'] == null) {
      return Directory.current;
    }
    final directory = Directory(results['output'] as String);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directory;
  }
}
