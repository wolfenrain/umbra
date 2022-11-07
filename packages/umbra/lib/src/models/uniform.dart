import 'package:equatable/equatable.dart';
import 'package:umbra/umbra.dart';

/// {@template uniform}
/// Describes a uniform of a shader.
/// {@endtemplate}
class Uniform extends Equatable {
  /// {@macro uniform}
  const Uniform(this.name, this.type, [this.hint]);

  /// {@macro uniform}
  ///
  /// Parse a uniform from string values.
  factory Uniform.parse(String name, String type, [String? hint]) {
    final uniformType = UniformType.parse(type);
    final uniformHint = UniformHint.parse(hint);

    if (!(uniformHint?.isValidType(uniformType) ?? true)) {
      // TODO(wolfen): proper exceptions.
      throw Exception('Given type $type is not valid for given $hint');
    }

    return Uniform(name, uniformType, uniformHint);
  }

  /// The type of the uniform.
  final UniformType type;

  /// The name of the uniform.
  final String name;

  /// The hint of the uniform.
  final UniformHint? hint;

  @override
  List<Object> get props => [name, type];
}
