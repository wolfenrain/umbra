import 'package:mason/mason.dart';

/// {@template template}
/// Dart class that represents a supported template.
///
/// Each template consists of a [MasonBundle], name, and help text describing
/// the template.
/// {@endtemplate}
abstract class Template {
  /// {@macro template}
  const Template({
    required this.name,
    required this.bundle,
    required this.help,
  });

  /// The name associated with this template.
  final String name;

  /// The [MasonBundle] used to generate this template.
  final MasonBundle bundle;

  /// The help text shown in the usage information for the CLI.
  final String help;
}
