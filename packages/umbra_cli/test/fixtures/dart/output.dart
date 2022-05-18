import 'dart:convert';
import 'dart:typed_data';

import 'dart:ui';

import 'package:umbra_flutter/umbra_flutter.dart';

/// {@template input}
/// A Dart Shader class for the `input` shader.
/// {@endtemplate}
class Input extends UmbraShader {
  Input._() : super(_cachedProgram!);

  /// {@macro input}
  static Future<Input> compile() async {
    // Caching the program on the first compile call.
    _cachedProgram ??= await FragmentProgram.compile(
      spirv: Uint8List.fromList(base64Decode(_spirv)).buffer,
    );

    return Input._();
  }

  static FragmentProgram? _cachedProgram;

  Shader shader({
    required Size resolution,
  }) {
    return program.shader(
      floatUniforms: Float32List.fromList([
        resolution.width,
        resolution.height,
      ]),
      samplerUniforms: [
      ],
    );
  }
}

const _spirv =
    'AwIjBwAAAQAKAA0AJAAAAAAAAAARAAIAAQAAAAsABgABAAAAR0xTTC5zdGQuNDUwAAAAAA4AAwAAAAAAAQAAAA8ABwAEAAAABAAAAG1haW4AAAAAEwAAABkAAAAQAAMABAAAAAgAAAADAAMAAQAAAEABAAAEAAoAR0xfR09PR0xFX2NwcF9zdHlsZV9saW5lX2RpcmVjdGl2ZQAABAAIAEdMX0dPT0dMRV9pbmNsdWRlX2RpcmVjdGl2ZQAFAAQABAAAAG1haW4AAAAABQAHAA8AAABmcmFnbWVudChzMjE7dmYyOwAAAAUABAANAAAAVEVYVFVSRQAFAAMADgAAAFVWAAAFAAQAEwAAAENPTE9SAAAABQADABcAAABVVgAABQAGABkAAABnbF9GcmFnQ29vcmQAAAAABQAFAB0AAAByZXNvbHV0aW9uAAAFAAQAIAAAAFRFWFRVUkUABQAEACEAAABwYXJhbQAAAEcAAwANAAAAAAAAAEcAAwAOAAAAAAAAAEcAAwATAAAAAAAAAEcABAATAAAAHgAAAAAAAABHAAMAFAAAAAAAAABHAAMAFQAAAAAAAABHAAMAFgAAAAAAAABHAAMAFwAAAAAAAABHAAQAGQAAAAsAAAAPAAAARwADAB0AAAAAAAAARwAEAB0AAAAeAAAAAAAAAEcAAwAeAAAAAAAAAEcAAwAgAAAAAAAAAEcABAAgAAAAHgAAAAEAAABHAAQAIAAAACIAAAAAAAAARwAEACAAAAAhAAAAAAAAAEcAAwAhAAAAAAAAAEcAAwAiAAAAAAAAABMAAgACAAAAIQADAAMAAAACAAAAFgADAAYAAAAgAAAAGQAJAAcAAAAGAAAAAQAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAGwADAAgAAAAHAAAAIAAEAAkAAAAAAAAACAAAABcABAAKAAAABgAAAAIAAAAgAAQACwAAAAcAAAAKAAAAIQAFAAwAAAACAAAACQAAAAsAAAAXAAQAEQAAAAYAAAAEAAAAIAAEABIAAAADAAAAEQAAADsABAASAAAAEwAAAAMAAAAgAAQAGAAAAAEAAAARAAAAOwAEABgAAAAZAAAAAQAAACAABAAcAAAAAAAAAAoAAAA7AAQAHAAAAB0AAAAAAAAAOwAEAAkAAAAgAAAAAAAAADYABQACAAAABAAAAAAAAAADAAAA+AACAAUAAAA7AAQACwAAABcAAAAHAAAAOwAEAAsAAAAhAAAABwAAAD0ABAARAAAAGgAAABkAAABPAAcACgAAABsAAAAaAAAAGgAAAAAAAAABAAAAPQAEAAoAAAAeAAAAHQAAAIgABQAKAAAAHwAAABsAAAAeAAAAPgADABcAAAAfAAAAPQAEAAoAAAAiAAAAFwAAAD4AAwAhAAAAIgAAADkABgACAAAAIwAAAA8AAAAgAAAAIQAAAP0AAQA4AAEANgAFAAIAAAAPAAAAAAAAAAwAAAA3AAMACQAAAA0AAAA3AAMACwAAAA4AAAD4AAIAEAAAAD0ABAAIAAAAFAAAAA0AAAA9AAQACgAAABUAAAAOAAAAVwAFABEAAAAWAAAAFAAAABUAAAA+AAMAEwAAABYAAAD9AAEAOAABAA==';
