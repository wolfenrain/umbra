import 'dart:io';
import 'package:path/path.dart' as path;

String testFixturesPath(Directory cwd, String shaderName) {
  return path.join(cwd.path, 'test', 'fixtures', 'shaders', '$shaderName.glsl');
}
