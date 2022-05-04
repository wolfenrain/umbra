import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart' hide packageVersion;
import 'package:umbra_cli/src/commands/commands.dart';
import 'package:umbra_cli/src/version.dart';

// The Google Analytics tracking ID.
const _gaTrackingId = 'UA-117465969-4';

// The Google Analytics Application Name.
const _gaAppName = 'very-good-cli';

/// The package name.
const packageName = 'umbra_cli';

/// {@template umbra_command_runner}
/// A [CommandRunner] for the Umbra CLI.
/// {@endtemplate}
class UmbraCommandRunner extends CommandRunner<int> {
  /// {@macro umbra_command_runner}
  UmbraCommandRunner({
    Logger? logger,
  })  : _logger = logger ?? Logger(),
        super('umbra-cli', 'Command Line Interface for Umbra') {
    argParser.addFlag(
      'version',
      negatable: false,
      help: 'Print the current version.',
    );
    addCommand(GenerateCommand(logger: _logger));
  }

  /// Standard timeout duration for the CLI.
  static const timeout = Duration(milliseconds: 500);

  final Logger _logger;

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final _argResults = parse(args);
      return await runCommand(_argResults) ?? ExitCode.success.code;
    } on FormatException catch (e, stackTrace) {
      _logger
        ..err(e.message)
        ..err('$stackTrace')
        ..info('')
        ..info(usage);
      return ExitCode.usage.code;
    } on UsageException catch (e) {
      _logger
        ..err(e.message)
        ..info('')
        ..info(usage);
      return ExitCode.usage.code;
    }
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    int? exitCode = ExitCode.unavailable.code;
    if (topLevelResults['version'] == true) {
      _logger.info(packageVersion);
      exitCode = ExitCode.success.code;
    } else {
      exitCode = await super.runCommand(topLevelResults);
    }
    return exitCode;
  }
}
