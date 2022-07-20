import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:umbra_flutter/umbra_flutter.dart';

/// {@template pixelation}
/// A Flutter Widget for the `pixelation` shader.
/// {@endtemplate}
class Pixelation extends UmbraWidget {
  /// {@macro pixelation}
  const Pixelation({
    super.key,
    super.blendMode = BlendMode.src,
    super.child,
    super.errorBuilder,
    super.compilingBuilder,
    required double pixelSize,
    required Image image,
  })  : _pixelSize = pixelSize,
        _image = image,
        super();

  static Future<FragmentProgram>? _cachedProgram;

  final double _pixelSize;

  final Image _image;

  @override
  List<double> getFloatUniforms() {
    return [
      _pixelSize,
    ];
  }

  @override
  List<ImageShader> getSamplerUniforms() {
    return [
      ImageShader(
        _image,
        TileMode.clamp,
        TileMode.clamp,
        UmbraShader.identity,
      ),
    ];
  }

  @override
  Future<FragmentProgram> program() {
    return _cachedProgram ??
        FragmentProgram.compile(
          spirv: Uint8List.fromList(base64Decode(_spirv)).buffer,
        );
  }
}

const _spirv =
    'AwIjBwAAAQAKAA0AVAAAAAAAAAARAAIAAQAAAAsABgABAAAAR0xTTC5zdGQuNDUwAAAAAA4AAwAAAAAAAQAAAA8ABwAEAAAABAAAAG1haW4AAAAARwAAAE0AAAAQAAMABAAAAAgAAAADAAMAAQAAAEABAAAEAAoAR0xfR09PR0xFX2NwcF9zdHlsZV9saW5lX2RpcmVjdGl2ZQAABAAIAEdMX0dPT0dMRV9pbmNsdWRlX2RpcmVjdGl2ZQAFAAQABAAAAG1haW4AAAAABQAGAA0AAABwaXhlbCh2ZjI7dmYyOwAABQADAAsAAABwb3MABQADAAwAAAByZXMABQAHABEAAABmcmFnbWVudCh2ZjI7dmYyOwAAAAUAAwAPAAAAdXYAAAUABQAQAAAAZnJhZ0Nvb3JkAAAABQAEADEAAABpbWFnZQAAAAUABQA4AAAAcmVzb2x1dGlvbgAABQAFADsAAABwaXhlbFNpemUAAAAFAAQAPwAAAHBhcmFtAAAABQAEAEEAAABwYXJhbQAAAAUAAwBFAAAAdXYAAAUABgBHAAAAZ2xfRnJhZ0Nvb3JkAAAAAAUABABNAAAAX0NPTE9SXwAFAAQATgAAAHBhcmFtAAAABQAEAFAAAABwYXJhbQAAAEcAAwANAAAAAAAAAEcAAwALAAAAAAAAAEcAAwAMAAAAAAAAAEcAAwARAAAAAAAAAEcAAwAPAAAAAAAAAEcAAwAQAAAAAAAAAEcAAwATAAAAAAAAAEcAAwAUAAAAAAAAAEcAAwAVAAAAAAAAAEcAAwAWAAAAAAAAAEcAAwAXAAAAAAAAAEcAAwAYAAAAAAAAAEcAAwAdAAAAAAAAAEcAAwAfAAAAAAAAAEcAAwAgAAAAAAAAAEcAAwAjAAAAAAAAAEcAAwAkAAAAAAAAAEcAAwAlAAAAAAAAAEcAAwAmAAAAAAAAAEcAAwAxAAAAAAAAAEcABAAxAAAAHgAAAAEAAABHAAQAMQAAACIAAAAAAAAARwAEADEAAAAhAAAAAAAAAEcAAwAyAAAAAAAAAEcAAwAzAAAAAAAAAEcAAwA0AAAAAAAAAEcAAwA4AAAAAAAAAEcABAA4AAAAHgAAAAIAAABHAAMAOQAAAAAAAABHAAMAOwAAAAAAAABHAAQAOwAAAB4AAAAAAAAARwADADwAAAAAAAAARwADAD0AAAAAAAAARwADAD4AAAAAAAAARwADAD8AAAAAAAAARwADAEAAAAAAAAAARwADAEEAAAAAAAAARwADAEIAAAAAAAAARwADAEUAAAAAAAAARwAEAEcAAAALAAAADwAAAEcAAwBKAAAAAAAAAEcAAwBNAAAAAAAAAEcABABNAAAAHgAAAAAAAABHAAMATgAAAAAAAABHAAMATwAAAAAAAABHAAMAUAAAAAAAAABHAAMAUwAAAAAAAAATAAIAAgAAACEAAwADAAAAAgAAABYAAwAGAAAAIAAAABcABAAHAAAABgAAAAIAAAAgAAQACAAAAAcAAAAHAAAAFwAEAAkAAAAGAAAABAAAACEABQAKAAAACQAAAAgAAAAIAAAAFQAEABkAAAAgAAAAAAAAACsABAAZAAAAGgAAAAAAAAAgAAQAGwAAAAcAAAAGAAAAKwAEAAYAAAAeAAAAAAAAPysABAAZAAAAIQAAAAEAAAAUAAIAJwAAACsABAAGAAAAKwAAAAAAAAAsAAcACQAAACwAAAArAAAAKwAAACsAAAArAAAAGQAJAC4AAAAGAAAAAQAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAGwADAC8AAAAuAAAAIAAEADAAAAAAAAAALwAAADsABAAwAAAAMQAAAAAAAAAgAAQANwAAAAAAAAAHAAAAOwAEADcAAAA4AAAAAAAAACAABAA6AAAAAAAAAAYAAAA7AAQAOgAAADsAAAAAAAAAIAAEAEYAAAABAAAACQAAADsABABGAAAARwAAAAEAAAAgAAQATAAAAAMAAAAJAAAAOwAEAEwAAABNAAAAAwAAADYABQACAAAABAAAAAAAAAADAAAA+AACAAUAAAA7AAQACAAAAEUAAAAHAAAAOwAEAAgAAABOAAAABwAAADsABAAIAAAAUAAAAAcAAAA9AAQACQAAAEgAAABHAAAATwAHAAcAAABJAAAASAAAAEgAAAAAAAAAAQAAAD0ABAAHAAAASgAAADgAAACIAAUABwAAAEsAAABJAAAASgAAAD4AAwBFAAAASwAAAD0ABAAHAAAATwAAAEUAAAA+AAMATgAAAE8AAAA9AAQACQAAAFEAAABHAAAATwAHAAcAAABSAAAAUQAAAFEAAAAAAAAAAQAAAD4AAwBQAAAAUgAAADkABgAJAAAAUwAAABEAAABOAAAAUAAAAD4AAwBNAAAAUwAAAP0AAQA4AAEANgAFAAkAAAANAAAAAAAAAAoAAAA3AAMACAAAAAsAAAA3AAMACAAAAAwAAAD4AAIADgAAAD0ABAAHAAAAEwAAAAsAAAA9AAQABwAAABQAAAAMAAAAhQAFAAcAAAAVAAAAEwAAABQAAAAMAAYABwAAABYAAAABAAAACAAAABUAAAA9AAQABwAAABcAAAAMAAAAiAAFAAcAAAAYAAAAFgAAABcAAAA+AAMACwAAABgAAABBAAUAGwAAABwAAAALAAAAGgAAAD0ABAAGAAAAHQAAABwAAACDAAUABgAAAB8AAAAdAAAAHgAAAAwABgAGAAAAIAAAAAEAAAAEAAAAHwAAAEEABQAbAAAAIgAAAAsAAAAhAAAAPQAEAAYAAAAjAAAAIgAAAIMABQAGAAAAJAAAACMAAAAeAAAADAAGAAYAAAAlAAAAAQAAAAQAAAAkAAAADAAHAAYAAAAmAAAAAQAAACgAAAAgAAAAJQAAALoABQAnAAAAKAAAACYAAAAeAAAA9wADACoAAAAAAAAA+gAEACgAAAApAAAAKgAAAPgAAgApAAAA/gACACwAAAD4AAIAKgAAAD0ABAAvAAAAMgAAADEAAAA9AAQABwAAADMAAAALAAAAVwAFAAkAAAA0AAAAMgAAADMAAAD+AAIANAAAADgAAQA2AAUACQAAABEAAAAAAAAACgAAADcAAwAIAAAADwAAADcAAwAIAAAAEAAAAPgAAgASAAAAOwAEAAgAAAA/AAAABwAAADsABAAIAAAAQQAAAAcAAAA9AAQABwAAADkAAAA4AAAAPQAEAAYAAAA8AAAAOwAAAFAABQAHAAAAPQAAADwAAAA8AAAAiAAFAAcAAAA+AAAAOQAAAD0AAAA9AAQABwAAAEAAAAAPAAAAPgADAD8AAABAAAAAPgADAEEAAAA+AAAAOQAGAAkAAABCAAAADQAAAD8AAABBAAAA/gACAEIAAAA4AAEA';
