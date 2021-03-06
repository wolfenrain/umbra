import 'dart:typed_data';
import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';

/// {@template umbra_shader}
/// The base class for all shaders generated by Umbra.
/// {@endtemplate}
abstract class UmbraShader {
  /// {@macro umbra_shader}
  UmbraShader(this.program);

  /// The [FragmentProgram] used by this shader.
  final FragmentProgram program;

  /// The identity used in [ImageShader]s.
  static final Float64List identity = Matrix4.identity().storage;
}
