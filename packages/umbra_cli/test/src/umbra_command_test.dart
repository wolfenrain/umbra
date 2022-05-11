import 'package:test/test.dart';
import 'package:umbra_cli/src/platform.dart';
import 'package:umbra_cli/src/umbra_command.dart';

class TestCommand extends UmbraCommand {
  @override
  String get description => 'test command';

  @override
  String get name => 'test';
}

void main() {
  group('UmbraCommand', () {
    group('find correct data directory', () {
      setUp(PlatformValues.test);

      tearDown(PlatformValues.reset);

      test('on macOS', () {
        PlatformValues.isMacOS = true;
        PlatformValues.environment = {'HOME': '/User/test'};

        final command = TestCommand();
        expect(command.dataDirectory.path, '/User/test/.umbra');
      });

      test('on Linux', () {
        PlatformValues.isLinux = true;
        PlatformValues.environment = {'HOME': '/home/test'};

        final command = TestCommand();
        expect(command.dataDirectory.path, '/home/test/.umbra');
      });

      test('on Windows', () {
        PlatformValues.isWindows = true;
        PlatformValues.environment = {'UserProfile': '/C/Users/test'};

        final command = TestCommand();
        expect(command.dataDirectory.path, '/C/Users/test/.umbra');
      });

      test('on unsupported platform', () {
        final command = TestCommand();
        expect(() => command.dataDirectory, throwsUnsupportedError);
      });
    });
  });
}
