import 'package:umbra/umbra.dart';
import 'package:umbra_cli/src/commands/generate/targets/targets.dart';
import 'package:umbra_cli/src/generators/generators.dart';

/// {@template spirv_binary_target}
/// A SPIR-V binary target.
/// {@endtemplate}
class SpirvBinaryTarget extends Target {
  /// {@macro spirv_binary_target}
  SpirvBinaryTarget()
      : super(
          name: 'spirv',
          extension: 'spirv',
          generator: (specification, cmd, dir) async => SpirvGenerator(
            specification,
            cmd: cmd,
            dataDirectory: dir,
            rawBytes: await RawGenerator(specification).generate(),
          ),
          help: 'Generate a SPIR-R binary.',
        );
}
