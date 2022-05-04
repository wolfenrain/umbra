import 'package:equatable/equatable.dart';
import 'package:umbra_core/umbra_core.dart';

/// The supported precision types.
enum PrecisionType {
  /// A high precision type.
  highp,

  /// A medium precision type.
  mediump,

  /// A low precision type.
  lowp,
}

/// {@template precision}
/// Describes the precision of a shader.
/// {@endtemplate}
class Precision extends Equatable {
  /// {@macro precision}
  const Precision(this.type, this.precision);

  /// {@macro precision}
  ///
  /// Parse the given line into a [Precision].
  factory Precision.parse(String line) {
    final data = line.split(RegExp(r'\s+'));

    final UniformType type;
    switch (data[2].replaceAll(';', '')) {
      case 'float':
        type = UniformType.float;
        break;
      default:
        throw Exception('Unsupported uniform type');
    }

    switch (data[1]) {
      case 'highp':
        return Precision(type, PrecisionType.highp);
      case 'mediump':
        return Precision(type, PrecisionType.mediump);
      case 'lowp':
        return Precision(type, PrecisionType.lowp);
      default:
        throw Exception('Unsupported precision');
    }
  }

  /// The precision type of a shader.
  final UniformType type;

  /// The precision type of a shader.
  final PrecisionType precision;

  @override
  String toString() {
    return 'precision ${precision.name} ${type.name}';
  }

  @override
  List<Object?> get props => [type, precision];
}
