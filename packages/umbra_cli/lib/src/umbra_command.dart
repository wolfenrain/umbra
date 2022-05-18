import 'dart:io' hide Platform;

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:umbra_cli/src/cmd/cmd.dart';
import 'package:umbra_cli/src/platform.dart';

/// {@template umbra_command}
/// The base class for all umbra executable commands.
/// {@endtemplate}
abstract class UmbraCommand extends Command<int> {
  /// {@macro umbra_command}
  UmbraCommand({
    Logger? logger,
    Platform? platform,
    Cmd? cmd,
  })  : _logger = logger,
        _platform = platform,
        _cmd = cmd;

  /// [ArgResults] used for testing purposes only.
  @visibleForTesting
  ArgResults? testArgResults;

  /// [ArgResults] for the current command.
  ArgResults get results => testArgResults ?? argResults!;

  /// [Logger] instance used to wrap stdout.
  Logger get logger => _logger ??= Logger();
  Logger? _logger;

  /// [Platform] instance for the current command.
  Platform get platform => _platform ??= Platform();
  Platform? _platform;

  /// [Cmd] instance for the current command.
  Cmd get cmd => _cmd ??= Cmd();
  Cmd? _cmd;

  /// The directory where umbra stores data.
  Directory get dataDirectory {
    final String home;
    if (platform.isMacOS || platform.isLinux) {
      home = platform.environment['HOME']!;
    } else if (platform.isWindows) {
      home = platform.environment['UserProfile']!;
    } else {
      throw UnsupportedError('Unsupported platform.');
    }
    return Directory(path.join(home, '.umbra'));
  }
}
