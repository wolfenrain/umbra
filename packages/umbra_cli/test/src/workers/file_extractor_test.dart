import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:umbra_cli/src/platform.dart';
import 'package:umbra_cli/src/workers/workers.dart';

import '../../helpers/set_up_testing_environment.dart';

void main() {
  final cwd = Directory.current;
  final archiveFixturePath = testFixturesPath(cwd, suffix: 'archives');
  const expectedBytes = [116, 101, 115, 116, 10];

  group('FileExtractor', () {
    group('extract a file from archive bytes', () {
      setUp(PlatformValues.test);

      tearDown(PlatformValues.reset);

      test('on MacOS', () async {
        PlatformValues.isMacOS = true;

        final result = await FileExtractor().extract(
          'folder/test.file',
          File(path.join(archiveFixturePath, 'test.tgz')).readAsBytesSync(),
        );

        expect(result, equals(expectedBytes));
      });

      test('on Linux', () async {
        PlatformValues.isLinux = true;

        final result = await FileExtractor().extract(
          'folder/test.file',
          File(path.join(archiveFixturePath, 'test.tgz')).readAsBytesSync(),
        );

        expect(result, equals(expectedBytes));
      });

      test('on Windows', () async {
        PlatformValues.isWindows = true;

        final result = await FileExtractor().extract(
          'folder/test.file',
          File(path.join(archiveFixturePath, 'test.zip')).readAsBytesSync(),
        );

        expect(result, equals(expectedBytes));
      });

      test('on unsupported platform', () async {
        await expectLater(
          () => FileExtractor().extract(
            'folder/test.file',
            File(path.join(archiveFixturePath, 'test.zip')).readAsBytesSync(),
          ),
          throwsUnsupportedError,
        );
      });
    });
  });
}
