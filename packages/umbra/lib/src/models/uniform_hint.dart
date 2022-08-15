import 'package:equatable/equatable.dart';
import 'package:umbra/umbra.dart';

/// {@template uniform_hint}
/// Represents a hint that describe the type for a [Uniform].
/// {@endtemplate}
abstract class UniformHint extends Equatable {
  /// {@macro uniform_hint}
  const UniformHint(this.key);

  /// {@macro uniform_hint}
  ///
  /// Parse the given string into a potential [UniformHint].
  static UniformHint? parse(String? hint) {
    switch (hint) {
      case 'color':
        return const _ColorHint();
    }
    return null;
  }

  /// The hint key.
  final String key;

  @override
  List<Object> get props => [key];

  /// Validate if the given type is valid for this hint.
  bool isValidType(UniformType type);

  @override
  String toString() => 'hint_$key';
}

class _ColorHint extends UniformHint {
  const _ColorHint() : super('color');

  @override
  bool isValidType(UniformType type) => type == UniformType.vec4;
}
