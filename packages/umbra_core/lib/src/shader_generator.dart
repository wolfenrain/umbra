import 'package:mason/mason.dart';
import 'package:mason/src/generator.dart';
import 'package:umbra_core/src/templates/create_umbra_shader_bundle.dart';
import 'package:umbra_core/umbra_core.dart';

class InMemoryGeneratorTarget extends GeneratorTarget {
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

class ShaderGenerator {
  ShaderGenerator(this.shader);

  final Shader shader;

  Future<String> generate() async {
    final generator = await MasonGenerator.fromBundle(createUmbraShaderBundle);

    final vars = <String, dynamic>{
      'name': shader.name,
      'version': shader.version,
      'precision': shader.precision,
      'uniforms': shader.uniforms
          .map((e) => 'layout (location = ${shader.uniforms.indexOf(e)}) $e;')
          .join('\n'),
      'userCode': shader.userCode.join('\n'),
    };
    // await generator.hooks.preGen(
    //   workingDirectory: cwd.path,
    //   onVarsChanged: (v) => vars = v,
    // );

    final target = InMemoryGeneratorTarget();
    final files = await generator.generate(
      target,
      vars: vars,
    );

    return String.fromCharCodes(target.generatedFiles[files.first.path]!);
  }
}
