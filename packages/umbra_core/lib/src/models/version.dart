import 'package:equatable/equatable.dart';

/// {@template shader_version}
/// The version of the shader.
/// {@endtemplate}
class Version extends Equatable {
  /// {@macro shader_version}
  const Version(this.version, [this.language]);

  /// {@macro shader_version}
  ///
  /// Parse the given string into a [Version].
  factory Version.parse(String version) {
    final data = version.split(' ');
    return Version(int.parse(data[1]), data[2]);
  }

  /// The version of the shader.
  ///
  /// For example, `320`, which is major version 3 with minor revision 20.
  final int version;

  /// The language of the shader.
  ///
  /// For example, `es`, which is the type of GLSL language used.
  final String? language;

  @override
  String toString() {
    return '#version $version ${language ?? ''}'.trim();
  }

  @override
  List<Object?> get props => [version, language];
}
