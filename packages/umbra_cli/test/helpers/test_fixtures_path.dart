import 'dart:io';

import 'package:path/path.dart' as path;

String testFixturesPath(Directory cwd, {String suffix = ''}) {
  return path.join(cwd.path, 'test', 'fixtures', suffix);
}
