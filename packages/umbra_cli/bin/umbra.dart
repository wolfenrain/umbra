import 'dart:io';

import 'package:umbra_core/umbra_core.dart';

Future<void> main(List<String> args) async {
  final input = Uri.parse(args[0]);
  final specification = ShaderSpecification.fromFile(File.fromUri(input));

  final generator = ShaderGenerator(specification);

  stdout.write(await generator.generate());
}
