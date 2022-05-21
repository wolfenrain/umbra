import 'dart:async';
import 'dart:io';

import 'package:umbra/umbra.dart';
import 'package:umbra_cli/src/cmd/cmd.dart';

/// A generator builder method.
typedef GeneratorBuilder = FutureOr<Generator> Function(
  ShaderSpecification specification,
  Cmd cmd,
  Directory dataDirectory,
);

/// {@template target}
/// Dart class that represents a supported target.
///
/// Each target consists of a [Generator], name, extension, and help text
/// describing the target.
/// {@endtemplate}
abstract class Target {
  /// {@macro target}
  const Target({
    required this.name,
    required this.extension,
    required this.generator,
    required this.help,
  });

  /// The target name associated with the [generator].
  final String name;

  /// The extension for the target file.
  final String extension;

  /// The [Generator] target.
  final GeneratorBuilder generator;

  /// The help text shown in the usage information for the CLI.
  final String help;
}
