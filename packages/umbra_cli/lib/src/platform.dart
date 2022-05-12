import 'dart:collection';
import 'dart:io' as io show Platform;

/// {@template platform}
/// Information about the platform on which the dart process is running.
/// {@endtemplate}
class Platform {
  /// {@macro platform}
  Platform({
    bool? isMacOS,
    bool? isLinux,
    bool? isWindows,
    Map<String, String>? environment,
  })  : isMacOS = isMacOS ?? io.Platform.isMacOS,
        isLinux = isLinux ?? io.Platform.isLinux,
        isWindows = isWindows ?? io.Platform.isWindows,
        environment = UnmodifiableMapView(
          environment ?? io.Platform.environment,
        );

  /// Whether the current platform is MacOS.
  final bool isMacOS;

  /// Whether the current platform is Linux.
  final bool isLinux;

  /// Whether the current platform is Windows.
  final bool isWindows;

  /// The environment for this process as a map from string key to string value.
  ///
  /// The map is unmodifiable.
  Map<String, String> environment;
}
