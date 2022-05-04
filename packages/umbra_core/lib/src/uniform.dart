import 'package:equatable/equatable.dart';

/// The type of uniforms supported.
enum UniformType {
  /// A float uniform.
  float,

  /// A vec2 uniform.
  vec2,

  /// A vec3 uniform.
  vec3,

  /// A vec4 uniform.
  vec4,

  /// A sampler2D uniform.
  sampler2D,
}

/// {@template uniform}
/// Describes a uniform of a shader.
/// {@endtemplate}
class Uniform extends Equatable {
  /// {@macro uniform}
  const Uniform(this.name, this.type);

  /// {@macro uniform}
  ///
  /// Parse a uniform from string values.
  factory Uniform.parse(String name, String type) {
    switch (type) {
      case 'float':
        return Uniform(name, UniformType.float);
      case 'vec2':
        return Uniform(name, UniformType.vec2);
      case 'vec3':
        return Uniform(name, UniformType.vec3);
      case 'vec4':
        return Uniform(name, UniformType.vec4);
      case 'sampler2D':
        return Uniform(name, UniformType.sampler2D);
    }
    throw Exception('Unsupported uniform type');
  }

  /// The type of the uniform.
  final UniformType type;

  /// The name of the uniform.
  final String name;

  @override
  String toString() {
    return 'uniform ${type.name} $name';
  }

  @override
  List<Object> get props => [name, type];
}
