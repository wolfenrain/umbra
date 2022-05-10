import 'package:mason/mason.dart';

/// {@template in_memory_generator_target}
/// A [GeneratorTarget] that stores the generated files in memory.
/// {@endtemplate}
class InMemoryGeneratorTarget extends GeneratorTarget {
  /// The generated files, stored by path name.
  final Map<String, List<int>> generatedFiles = {};

  @override
  Future<GeneratedFile> createFile(
    String path,
    List<int> contents, {
    Logger? logger,
    OverwriteRule? overwriteRule,
  }) async {
    generatedFiles[path] = contents;

    return GeneratedFile.skipped(path: path);
  }
}
