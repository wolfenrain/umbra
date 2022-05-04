import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart' hide packageVersion;
import 'package:path/path.dart' as path;
import 'package:umbra_core/umbra_core.dart';

/// A method which returns a [Future<MasonGenerator>] given a [MasonBundle].
typedef GeneratorBuilder = Future<MasonGenerator> Function(MasonBundle);

/// {@template raw_command}
/// Generate a raw GLSL shader file based on the given shader file.
/// {@endtemplate}
class RawCommand extends Command<int> {
  /// {@macro raw_command}
  RawCommand({
    Logger? logger,
  }) : _logger = logger ?? Logger() {
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'The output directory for the generated files.',
    );
  }

  final Logger _logger;

  @override
  String get description =>
      'Generate a raw GLSL shader file based on the given shader file';

  @override
  String get summary => '$invocation\n$description';

  @override
  String get name => 'raw';

  @override
  String get invocation => 'umbra-cli generate raw <input shader file>';

  ArgResults get _argResults => argResults!;

  @override
  Future<int> run() async {
    final shaderSpecification = _shaderSpecification;
    final outputDirectory = _outputDirectory;
    final outputFile = File(
      path.join(outputDirectory.path, '${shaderSpecification.name}.glsl'),
    );
    final generateDone = _logger.progress('Bootstrapping');

    final generator = ShaderGenerator(shaderSpecification);
    final result = await generator.generate();
    await outputFile.writeAsString(result);

    generateDone('Generated ${outputFile.path}');

    return ExitCode.success.code;
  }

  /// Gets the shader specification.
  ShaderSpecification get _shaderSpecification {
    final rest = _argResults.rest;
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
    if (_argResults['output'] == null) {
      return Directory.current;
    }
    final directory = Directory(_argResults['output'] as String);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directory;
  }
}
