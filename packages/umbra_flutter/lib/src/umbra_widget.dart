import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:umbra_flutter/umbra_flutter.dart';

/// Signature used by [UmbraWidget.errorBuilder] to create a
/// replacement widget to render instead of the shader.
typedef ShaderErrorWidgetBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
);

/// Signature used by [UmbraWidget.compilingBuilder] to create a widget to show
/// while the shader is compiling.
///
/// The [child] is the same child passed to the [UmbraWidget] constructor.
typedef ShaderCompilingBuilder = Widget Function(
  BuildContext context,
  Widget? child,
);

/// {@template umbra_widget}
/// Abstract widget that shader widgets who are generated by Umbra will use.
/// {@endtemplate}
abstract class UmbraWidget extends StatelessWidget {
  /// {@macro umbra_widget}
  const UmbraWidget({
    super.key,
    this.blendMode = BlendMode.src,
    this.child,
    this.errorBuilder,
    this.compilingBuilder,
  });

  /// The blend mode to use when applying the shader mask.
  final BlendMode blendMode;

  /// The optional child widget to apply the shader mask to.
  final Widget? child;

  /// A builder function that is called if an error occurs during shader
  /// compilation.
  final ShaderErrorWidgetBuilder? errorBuilder;

  /// A builder that specifies the widget to display to the user while a
  /// shader is still compiling.
  final ShaderCompilingBuilder? compilingBuilder;

  /// The Fragment Shader program to use.
  Future<FragmentProgram> program();

  /// Returns the float uniforms to pass to the shader.
  List<double> getFloatUniforms();

  /// Returns the sampler uniforms to pass to the shader.
  List<ImageShader> getSamplerUniforms();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FragmentProgram>(
      future: program(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          var error = snapshot.error!;
          if (error.runtimeType.toString() == 'TranspileException') {
            error = UmbraException(error as Exception);
          }
          if (errorBuilder != null) {
            return errorBuilder!(context, error, snapshot.stackTrace);
          }
          return ErrorWidget(error);
        }
        if (!snapshot.hasData) {
          if (compilingBuilder != null) {
            return compilingBuilder!(context, child);
          }
          return child ?? const SizedBox();
        }
        final program = snapshot.data!;

        return LayoutBuilder(
          builder: (context, constraints) {
            return ShaderMask(
              blendMode: blendMode,
              shaderCallback: (bounds) {
                return program.shader(
                  floatUniforms: Float32List.fromList(
                    getFloatUniforms()
                      ..addAll([bounds.size.width, bounds.size.height]),
                  ),
                  samplerUniforms: getSamplerUniforms(),
                );
              },
              child: Container(
                color: Colors.transparent,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}
