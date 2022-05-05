import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';

/// {@template umbra_command}
/// The base class for all umbra executable commands.
/// {@endtemplate}
abstract class UmbraCommand extends Command<int> {
  /// {@macro umbra_command}
  UmbraCommand({Logger? logger}) : _logger = logger;

  /// [ArgResults] used for testing purposes only.
  // @visibleForTesting
  ArgResults? testArgResults;

  /// [ArgResults] for the current command.
  ArgResults get results => testArgResults ?? argResults!;

  /// [Logger] instance used to wrap stdout.
  Logger get logger => _logger ??= Logger();

  Logger? _logger;
}
