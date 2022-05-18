import 'package:umbra_cli/src/commands/create/templates/templates.dart';

/// {@template simple_shader_template}
/// A simple shader template.
/// {@endtemplate}
class SimpleShaderTemplate extends Template {
  /// {@macro simple_shader_template}
  SimpleShaderTemplate()
      : super(
          name: 'simple',
          bundle: simpleShaderBundle,
          help: 'Create a simple shader.',
        );
}
