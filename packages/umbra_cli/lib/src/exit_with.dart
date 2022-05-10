import 'package:mason/mason.dart';

/// {@template exit_with}
/// An exception that can be used to exit the CLI with a specific exit code.
/// {@endtemplate}
class ExitWith implements Exception {
  /// {@macro exit_with}
  ExitWith(this.exit);

  /// The exit code to use when exiting the CLI.
  final ExitCode exit;
}
