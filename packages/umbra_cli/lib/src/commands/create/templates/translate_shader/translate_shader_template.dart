import 'package:umbra_cli/src/commands/create/templates/templates.dart';

/// {@template translate_shader_template}
/// A translate shader template.
/// {@endtemplate}
class TranslateShaderTemplate extends Template {
  /// {@macro translate_shader_template}
  TranslateShaderTemplate()
      : super(
          name: 'translate',
          bundle: translateShaderBundle,
          help: 'Create a translating shader.',
        );
}
