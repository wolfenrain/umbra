import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart' hide packageVersion;
import 'package:umbra_cli/src/commands/create/templates/templates.dart';
import 'package:umbra_cli/src/umbra_command.dart';

final _templates = [
  SimpleShaderTemplate(),
  TranslateShaderTemplate(),
];

final _defaultTemplate = _templates.first;

/// A method which returns a [Future<MasonGenerator>] given a [MasonBundle].
typedef GeneratorBuilder = Future<MasonGenerator> Function(MasonBundle);

/// {@template create_command}
/// `umbra create` command which creates Umbra shaders.
/// {@endtemplate}
class CreateCommand extends UmbraCommand {
  /// {@macro create_command}
  CreateCommand({
    super.logger,
    super.cmd,
    super.platform,
    GeneratorBuilder? generator,
  }) : _generator = generator ?? MasonGenerator.fromBundle {
    argParser
      ..addOption(
        'output',
        abbr: 'o',
        help: 'The output directory for the created file.',
      )
      ..addOption(
        'type',
        abbr: 't',
        help: 'The type used to create this new shader.',
        defaultsTo: _defaultTemplate.name,
        allowed: _templates.map((element) => element.name).toList(),
        allowedHelp: _templates.fold<Map<String, String>>(
          {},
          (previousValue, element) => {
            ...previousValue,
            element.name: element.help,
          },
        ),
      );
  }

  @override
  final String description = 'Create a new Umbra Shader.';

  @override
  final String name = 'create';

  final GeneratorBuilder _generator;

  String get _fileName {
    final rest = results.rest;
    if (rest.isEmpty || rest.first.isEmpty) {
      throw UsageException('No name specified.', usage);
    }
    return rest.first;
  }

  Directory get _outputDirectory {
    final directory = results['output'] == null
        ? Directory.current
        : Directory(results['output'] as String);

    if (!directory.existsSync()) {
      throw UsageException(
        'Directory "${directory.path}" does not exist.',
        usage,
      );
    }
    return directory;
  }

  Template get _template {
    final templateName = results['type'] as String?;

    return _templates.firstWhere(
      (element) => element.name == templateName,
      orElse: () => _defaultTemplate,
    );
  }

  @override
  Future<int> run() async {
    final fileName = _fileName;
    final outputDirectory = _outputDirectory;
    final template = _template;

    final createDone = logger.progress('Creating a Umbra Shader');
    final generator = await _generator(template.bundle);
    await generator.generate(
      DirectoryGeneratorTarget(outputDirectory),
      vars: <String, String>{'name': fileName},
      logger: logger,
    );
    createDone('Created a Umbra Shader!');

    return ExitCode.success.code;
  }
}
