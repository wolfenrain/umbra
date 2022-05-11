import 'package:test/test.dart';
import 'package:umbra_cli/src/platform.dart';

void main() {
  group('Platform', () {
    setUp(PlatformValues.test);

    tearDown(PlatformValues.reset);

    test('isMacOS', () {
      PlatformValues.isMacOS = true;

      final platform = Platform();
      expect(platform.isMacOS, isTrue);
      expect(platform.isLinux, isFalse);
      expect(platform.isWindows, isFalse);
    });

    test('isLinux', () {
      PlatformValues.isLinux = true;

      final platform = Platform();
      expect(platform.isMacOS, isFalse);
      expect(platform.isLinux, isTrue);
      expect(platform.isWindows, isFalse);
    });

    test('isWindows', () {
      PlatformValues.isWindows = true;

      final platform = Platform();
      expect(platform.isMacOS, isFalse);
      expect(platform.isLinux, isFalse);
      expect(platform.isWindows, isTrue);
    });

    test('environment', () {
      PlatformValues.environment = {'HOME': '/home/test'};

      final platform = Platform();
      expect(platform.environment, equals({'HOME': '/home/test'}));
    });
  });
}
