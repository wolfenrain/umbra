import 'dart:io';

import 'package:path/path.dart' as path;

class Fixture {
  Fixture(String input, this.fileName)
      : input = List.unmodifiable(input.split('\n'));

  final List<String> input;

  final String fileName;

  /// Returns the file to the raw fixture.
  File toRaw(Directory cwd) {
    return File.fromUri(
      Uri.parse(
        path.join(cwd.path, 'test', 'fixtures', 'raw', fileName),
      ),
    );
  }

  /// Returns the file to the dart fixture.
  File toDart(Directory cwd) {
    return File.fromUri(
      Uri.parse(
        path.join(cwd.path, 'test', 'fixtures', 'dart', fileName),
      ),
    );
  }
}
