import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:umbra_cli/src/cmd/cmd.dart';
import 'package:umbra_core/umbra_core.dart';

/// {@template spirv_generator}
/// A generator for generating SPIR-V binary files.
/// {@endtemplate}
class SpirvGenerator extends Generator {
  /// {@macro spirv_generator}
  SpirvGenerator(
    super.specification, {
    required Directory dataDirectory,
    required List<int> rawBytes,
    required Cmd cmd,
  })  : _cmd = cmd,
        _rawBytes = rawBytes,
        _dataDirectory = dataDirectory;

  final List<int> _rawBytes;

  final Cmd _cmd;

  final Directory _dataDirectory;

  @override
  Future<List<int>> generate() async {
    final tempDir = Directory.systemTemp.createTempSync();
    final input = File(path.join(tempDir.path, 'raw.glsl'))
      ..writeAsBytesSync(_rawBytes);
    final output = File(path.join(tempDir.path, 'spirv'));

    final List<int> bytes;
    try {
      await _cmd.start(
        path.join(_dataDirectory.path, 'bin', 'glslc'),
        [
          '--target-env=opengl',
          '-fshader-stage=fragment',
          '-o',
          output.path,
          input.path
        ],
      );
      bytes = output.readAsBytesSync();
    } finally {
      tempDir.deleteSync(recursive: true);
    }

    return bytes;
  }
}
