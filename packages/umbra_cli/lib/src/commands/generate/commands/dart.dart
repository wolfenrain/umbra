import 'package:mason/mason.dart' hide packageVersion;
import 'package:umbra_cli/src/commands/generate/commands/base_generate_command.dart';
import 'package:umbra_core/umbra_core.dart';

/// {@template dart_command}
/// Generate a Dart Shader file based on the given shader file.
/// {@endtemplate}
class DartCommand extends BaseGenerateCommand {
  /// {@macro dart_command}
  DartCommand({
    Logger? logger,
  }) : super(logger: logger, generator: DartGenerator.new);

  @override
  String get description => 'Generate a Dart Shader file.';

  @override
  String get name => 'dart';

  @override
  String get invocation => 'umbra generate dart <input shader file>';

  @override
  String get extension => 'dart';
}
