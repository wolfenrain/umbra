import 'package:umbra/umbra.dart';
import 'package:umbra_cli/src/commands/generate/targets/targets.dart';
import 'package:umbra_cli/src/generators/generators.dart';

/// {@template flutter_widget_target}
/// A Flutter Widget target.
/// {@endtemplate}
class FlutterWidgetTarget extends Target {
  /// {@macro flutter_widget_target}
  FlutterWidgetTarget()
      : super(
          name: 'flutter-widget',
          extension: 'dart',
          generator: (specification, cmd, dir) async => FlutterWidgetGenerator(
            specification,
            spirvBytes: await SpirvGenerator(
              specification,
              cmd: cmd,
              dataDirectory: dir,
              rawBytes: await RawShaderGenerator(specification).generate(),
            ).generate(),
          ),
          help: 'Generate a Flutter Widget.',
        );
}
