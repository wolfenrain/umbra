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

  /// A square float-matrix uniform.
  mat4;

  /// Parse the given string into an enum value.
  static UniformType parse(String type) {
    switch (type) {
      case 'float':
        return UniformType.float;
      case 'vec2':
        return UniformType.vec2;
      case 'vec3':
        return UniformType.vec3;
      case 'vec4':
        return UniformType.vec4;
      case 'sampler2D':
        return UniformType.sampler2D;
      case 'mat4':
        return UniformType.mat4;
    }
    // TODO(wolfen): proper exceptions.
    throw Exception('Unsupported uniform type');
  }
}
