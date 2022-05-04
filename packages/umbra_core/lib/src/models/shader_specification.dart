import 'dart:io';

import 'package:umbra_core/umbra_core.dart';

final _uniformRegexp = RegExp(r'uniform\s+(\w+)\s+(\w+);');

/// {@template shader}
/// Represents a shader.
/// {@endtemplate}
class ShaderSpecification {
  const ShaderSpecification._(
    this.name,
    this.version,
    this.precision,
    this.uniforms,
    this.userCode,
  );

  /// {@macro shader}
  ///
  /// Parsed directly from a file.
  factory ShaderSpecification.fromFile(File file) {
    return ShaderSpecification.parse(
      file.path.split('/').last.split('.').first,
      file.readAsLinesSync(),
    );
  }

  /// {@macro shader}
  ///
  /// Parsed directly from a string.
  factory ShaderSpecification.parse(String name, List<String> lines) {
    final uniforms = <Uniform>[];
    final remainders = <String>[];
    var version = const Version(320, 'es');
    var precision = const Precision(UniformType.float, PrecisionType.mediump);

    for (final line in lines) {
      if (line.startsWith('#version')) {
        version = Version.parse(line);
      } else if (line.startsWith('precision')) {
        precision = Precision.parse(line);
      } else if (_uniformRegexp.hasMatch(line)) {
        final match = _uniformRegexp.firstMatch(line)!;
        uniforms.add(Uniform.parse(match.group(2)!, match.group(1)!));
      } else {
        remainders.add(line);
      }
    }
    final userCode = <String>[];

    // Trim down the remainders to remove any blank lines at start and end.
    var trimmingStart = true;
    for (var i = 0; i < remainders.length; i++) {
      trimmingStart = remainders[i].isEmpty && trimmingStart;
      if (trimmingStart) {
        continue;
      } else {
        // Trim the end off
        if (remainders.sublist(i).every((remainder) => remainder.isEmpty)) {
          break;
        }
      }

      userCode.add(remainders[i]);
    }
    uniforms.add(const Uniform('resolution', UniformType.vec2));

    return ShaderSpecification._(
      name,
      version,
      precision,
      List.unmodifiable(uniforms),
      List.unmodifiable(userCode),
    );
  }

  /// The name of the shader file.
  final String name;

  /// The precision of the shader.
  final Precision precision;

  /// The version of the shader.
  final Version? version;

  /// The uniforms of the shader.
  final List<Uniform> uniforms;

  /// The user code of the shader.
  final List<String> userCode;
}
