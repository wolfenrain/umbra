import 'dart:io';

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
        valueHelp: 'directory',
      )
      ..addOption(
        'template',
        abbr: 't',
        help: 'The template used to create this new shader.',
        defaultsTo: _defaultTemplate.name,
        valueHelp: 'template',
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

  @override
  String get invocation => 'umbra create <shader_name>';

  String get _fileName {
    final rest = results.rest;
    if (rest.isEmpty || rest.first.isEmpty) {
      usageException('No name specified.');
    }
    return rest.first;
  }

  Directory get _outputDirectory {
    final directory = results['output'] == null
        ? Directory.current
        : Directory(results['output'] as String);

    if (!directory.existsSync()) {
      usageException(
        'Directory "${directory.path}" does not exist.',
      );
    }
    return directory;
  }

  Template get _template {
    final templateName = results['template'] as String?;

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

    final createProcess = logger.progress('Creating an Umbra Shader');
    final generator = await _generator(template.bundle);

    Future<GeneratedFile> generate({
      FileConflictResolution resolution = FileConflictResolution.skip,
    }) async {
      final files = await generator.generate(
        DirectoryGeneratorTarget(outputDirectory),
        vars: <String, String>{'name': fileName},
        logger: logger,
        fileConflictResolution: resolution,
      );
      return files.first;
    }

    final file = await generate();

    if (file.status == GeneratedFileStatus.skipped) {
      final fileName = file.path.split(RegExp(r'[/\\]')).last;
      final answer = logger.confirm('${yellow.wrap('Overwrite $fileName?')}');
      if (!answer) {
        createProcess.fail();
        logger.err('Aborting.');
        return ExitCode.cantCreate.code;
      }
      await generate(resolution: FileConflictResolution.overwrite);
    }
    createProcess.complete('Created an Umbra Shader!');

    return ExitCode.success.code;
  }
}
