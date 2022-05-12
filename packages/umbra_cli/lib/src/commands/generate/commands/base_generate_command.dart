import 'dart:io';

import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:umbra_cli/src/exit_with.dart';
import 'package:umbra_cli/src/umbra_command.dart';
import 'package:umbra_core/umbra_core.dart';

/// {@template base_generate_command}
/// Base class for all generate commands.
/// {@endtemplate}
abstract class BaseGenerateCommand extends UmbraCommand {
  /// {@macro base_generate_command}
  BaseGenerateCommand({super.logger, super.cmd, super.platform}) {
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'The output directory for the generated files.',
    );
  }

  /// The extension of the file to generate.
  String get extension;

  @override
  String get invocation => 'umbra generate $name <input shader file>';

  /// Generate file based on the [specification].
  Future<List<int>> generate(ShaderSpecification specification);

  @override
  @mustCallSuper
  Future<int> run() async {
    final ShaderSpecification shaderSpecification;
    try {
      final parsingShader = logger.progress('Parsing shader file');
      shaderSpecification = _parseShaderSpecification();
      parsingShader('Shader file parsed');
    } catch (err) {
      if (err is ExitWith) {
        if (err.message != null) {
          logger.err(err.message);
        }
        return err.exit.code;
      }
      rethrow;
    }

    final fileName = '${shaderSpecification.name}.$extension';

    final generateDone = logger.progress('Generating "$fileName"');
    final List<int> result;
    try {
      result = await generate(shaderSpecification);
    } catch (err) {
      if (err is ExitWith) {
        if (err.message != null) {
          logger.err(err.message);
        }
        return err.exit.code;
      }
      rethrow;
    }

    try {
      writeToFile(result, getFile(fileName));
      generateDone('Generated "$fileName"');
      return ExitCode.success.code;
    } catch (err) {
      if (err is ExitWith) {
        if (err.exit == ExitCode.cantCreate) {
          generateDone('Skipped "$fileName"');
          return err.exit.code;
        }
      }
      rethrow;
    }
  }

  /// Write the given [bytes] to the given [file].
  void writeToFile(List<int> bytes, File? file) {
    if (file == null) {
      return logger.info(String.fromCharCodes(bytes));
    }
    if (file.existsSync()) {
      final answer = logger.confirm(
        '  ${yellow.wrap('Overwrite "${file.path}"?')}',
      );
      if (!answer) {
        logger.err('Aborting.');
        throw ExitWith(ExitCode.cantCreate);
      }
    }
    file.writeAsBytesSync(bytes);
  }

  /// Gets the output file.
  File? getFile(String fileName) {
    if (results['output'] == '-') {
      return null;
    }
    final directory = results['output'] == null
        ? Directory.current
        : Directory(results['output'] as String);

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return File(
      path.join(directory.path, fileName),
    );
  }

  ShaderSpecification _parseShaderSpecification() {
    final rest = results.rest;
    if (rest.isEmpty) {
      throw ExitWith(ExitCode.noInput, 'No input shader file specified.');
    }
    try {
      final file = ShaderSpecification.fromFile(File(rest.first));
      return file;
    } catch (err) {
      if (err is ArgumentError) {
        throw ExitWith(ExitCode.noInput, err.message as String);
      }
      rethrow;
    }
  }
}
