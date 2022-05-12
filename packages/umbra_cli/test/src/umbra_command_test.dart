import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:umbra_cli/src/platform.dart';
import 'package:umbra_cli/src/umbra_command.dart';

class MockPlatform extends Mock implements Platform {}

class TestCommand extends UmbraCommand {
  TestCommand({super.platform});

  @override
  String get description => 'test command';

  @override
  String get name => 'test';
}

void main() {
  group('UmbraCommand', () {
    late Platform platform;

    setUp(() {
      platform = MockPlatform();
      when(() => platform.isMacOS).thenReturn(false);
      when(() => platform.isLinux).thenReturn(false);
      when(() => platform.isWindows).thenReturn(false);
      when(() => platform.environment).thenReturn({});
    });

    group('find correct data directory', () {
      test('on macOS', () {
        when(() => platform.isMacOS).thenReturn(true);
        when(() => platform.environment).thenReturn({'HOME': '/User/test'});

        final command = TestCommand(platform: platform);
        expect(command.dataDirectory.path, '/User/test/.umbra');
      });

      test('on Linux', () {
        when(() => platform.isLinux).thenReturn(true);
        when(() => platform.environment).thenReturn({'HOME': '/home/test'});

        final command = TestCommand(platform: platform);
        expect(command.dataDirectory.path, '/home/test/.umbra');
      });

      test('on Windows', () {
        when(() => platform.isWindows).thenReturn(true);
        when(() => platform.environment)
            .thenReturn({'UserProfile': '/C/Users/test'});

        final command = TestCommand(platform: platform);
        expect(command.dataDirectory.path, '/C/Users/test/.umbra');
      });

      test('on unsupported platform', () {
        final command = TestCommand(platform: platform);
        expect(() => command.dataDirectory, throwsUnsupportedError);
      });
    });
  });
}
