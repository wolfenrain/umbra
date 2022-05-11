import 'dart:collection';
import 'dart:io' as io show Platform;

import 'package:meta/meta.dart';

/// {@template platform}
/// Information about the platform on which the dart process is running.
/// {@endtemplate}
class Platform {
  /// {@macro platform}
  Platform()
      : isMacOS = PlatformValues.isMacOS,
        isLinux = PlatformValues.isLinux,
        isWindows = PlatformValues.isWindows,
        environment = UnmodifiableMapView(PlatformValues.environment);

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

/// The values for the platform. Only should be used by [Platform].
@visibleForTesting
class PlatformValues {
  /// Whether the current platform is MacOS.
  static bool isMacOS = io.Platform.isMacOS;

  /// Whether the current platform is Linux.
  static bool isLinux = io.Platform.isLinux;

  /// Whether the current platform is Windows.
  static bool isWindows = io.Platform.isWindows;

  /// The environment for this process as a map from string key to string value.
  static Map<String, String> environment = io.Platform.environment;

  /// Resets the values to their initial values.
  static void reset() {
    isMacOS = io.Platform.isMacOS;
    isLinux = io.Platform.isLinux;
    isWindows = io.Platform.isWindows;
    environment = io.Platform.environment;
  }

  /// Sets the values to an empty state for testing purposes.
  static void test() {
    isMacOS = false;
    isLinux = false;
    isWindows = false;
    environment = {};
  }
}
