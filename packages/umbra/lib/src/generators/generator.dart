import 'package:umbra/umbra.dart';

/// {@template generator}
/// Abstract generator for generating files based on a [ShaderSpecification].
/// {@endtemplate}
abstract class Generator {
  /// {@macro generator}
  Generator(this.specification);

  /// The shader specification input.
  final ShaderSpecification specification;

  /// Generates the files based on the [specification].
  Future<List<int>> generate();
}
