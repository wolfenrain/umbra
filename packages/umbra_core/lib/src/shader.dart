import 'package:umbra_core/umbra_core.dart';

final _uniformRegexp = RegExp(r'uniform\s+(\w+)\s+(\w+);');

/// {@template shader}
/// Represents a shader.
/// {@endtemplate}
class Shader {
  const Shader._(
    this.version,
    this.precision,
    this.uniforms,
    this._remainders,
  );

  /// {@macro shader}
  factory Shader.parse(String shaderCode) {
    final lines = shaderCode.split('\n');
    final uniforms = <Uniform>[];
    final remainders = <String>[];
    var version = const Version(320, 'es');
    var precision = const Precision(UniformType.float, PrecisionType.mediump);

    for (final line in lines) {
      if (line.startsWith('#version')) {
        version = Version.parse(lines.first);
      } else if (line.startsWith('precision')) {
        precision = Precision.parse(line);
      } else if (_uniformRegexp.hasMatch(line)) {
        final match = _uniformRegexp.firstMatch(line)!;
        uniforms.add(Uniform.parse(match.group(2)!, match.group(1)!));
      } else {
        remainders.add(line);
      }
    }
    final trueRemainders = <String>[];
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

      trueRemainders.add(remainders[i]);
    }

    return Shader._(
      version,
      precision,
      List.unmodifiable(uniforms),
      trueRemainders,
    );
  }

  /// The precision of the shader.
  final Precision precision;

  /// The version of the shader.
  final Version? version;

  /// The uniforms of the shader.
  final List<Uniform> uniforms;

  final List<String> _remainders;

  @override
  String toString() {
    final uniformLength = uniforms.length;

    return [
      '''
$version

$precision

layout (location = 0) out vec4 COLOR;

// User defined uniforms
${uniforms.map((uniform) => 'layout (location = ${uniforms.indexOf(uniform)}) $uniform').join('\n')}

// Flutter shader defined uniforms
layout (location = $uniformLength) uniform vec2 resolution;

void main()
{
    vec2 UV = gl_FragCoord.xy / resolution.xy;

    fragment(TEXTURE, UV);
}

// User defined code''',
      ..._remainders,
    ].join('\n');
  }
}
