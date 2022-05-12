import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:umbra_cli/src/platform.dart';
import 'package:umbra_cli/src/workers/workers.dart';

import '../../helpers/set_up_testing_environment.dart';

class _MockPlatform extends Mock implements Platform {}

void main() {
  final cwd = Directory.current;
  final archiveFixturePath = testFixturesPath(cwd, suffix: 'archives');
  const expectedBytes = [116, 101, 115, 116, 10];

  group('FileExtractor', () {
    late Platform platform;

    setUp(() {
      platform = _MockPlatform();
      when(() => platform.isMacOS).thenReturn(false);
      when(() => platform.isLinux).thenReturn(false);
      when(() => platform.isWindows).thenReturn(false);
      when(() => platform.environment).thenReturn({});
    });

    group('extract a file from archive bytes', () {
      test('on MacOS', () async {
        when(() => platform.isMacOS).thenReturn(true);

        final result = await FileExtractor(platform: platform).extract(
          'folder/test.file',
          File(path.join(archiveFixturePath, 'test.tgz')).readAsBytesSync(),
        );

        expect(result, equals(expectedBytes));
      });

      test('on Linux', () async {
        when(() => platform.isLinux).thenReturn(true);

        final result = await FileExtractor(platform: platform).extract(
          'folder/test.file',
          File(path.join(archiveFixturePath, 'test.tgz')).readAsBytesSync(),
        );

        expect(result, equals(expectedBytes));
      });

      test('on Windows', () async {
        when(() => platform.isWindows).thenReturn(true);

        final result = await FileExtractor(platform: platform).extract(
          'folder/test.file',
          File(path.join(archiveFixturePath, 'test.zip')).readAsBytesSync(),
        );

        expect(result, equals(expectedBytes));
      });

      test('on unsupported platform', () async {
        await expectLater(
          () => FileExtractor(platform: platform).extract(
            'folder/test.file',
            File(path.join(archiveFixturePath, 'test.zip')).readAsBytesSync(),
          ),
          throwsUnsupportedError,
        );
      });
    });
  });
}
