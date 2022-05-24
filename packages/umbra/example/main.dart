import 'dart:io';

import 'package:umbra/umbra.dart';

Future<void> main() async {
  for (final file in [
    File('./shaders/simple.glsl'),
    File('./shaders/with_precision.glsl'),
    File('./shaders/with_uniforms.glsl'),
    File('./shaders/with_version.glsl'),
  ]) {
    final specification = ShaderSpecification.fromFile(file);

    final generator = RawGenerator(specification);
    final rawBytes = await generator.generate();

    File(file.path.replaceAll('/shaders/', '/')).writeAsBytesSync(rawBytes);
  }
}
