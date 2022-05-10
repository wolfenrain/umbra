import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:umbra_cli/src/exit_with.dart';
import 'package:umbra_cli/src/umbra_command.dart';
import 'package:umbra_core/umbra_core.dart';

/// Builder for Generator commands.
typedef GeneratorBuilder = Generator Function(ShaderSpecification);

/// {@template base_generate_command}
/// Base class for all generate commands.
/// {@endtemplate}
abstract class BaseGenerateCommand extends UmbraCommand {
  /// {@macro base_generate_command}
  BaseGenerateCommand({
    Logger? logger,
    required GeneratorBuilder generator,
  })  : _generatorBuilder = generator,
        super(logger: logger) {
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'The output directory for the generated files.',
    );
  }

  final GeneratorBuilder _generatorBuilder;

  /// The extension of the file to generate.
  String get extension;

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
        if (err.exit == ExitCode.noInput) {
          throw UsageException(
            'Input shader file does not exist or is not specified',
            usage,
          );
        }
      }
      rethrow;
    }

    final fileName = '${shaderSpecification.name}.$extension';

    final generateDone = logger.progress('Generating "$fileName"');
    final generator = _generatorBuilder(shaderSpecification);
    final result = await generator.generate();
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
      return stdout.write(String.fromCharCodes(bytes));
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
      throw ExitWith(ExitCode.noInput);
    }
    try {
      final file = ShaderSpecification.fromFile(File(rest.first));
      return file;
    } catch (err) {
      if (err is ArgumentError) {
        throw ExitWith(ExitCode.noInput);
      }
      rethrow;
    }
  }
}
