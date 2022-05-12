import 'package:archive/archive_io.dart';
import 'package:umbra_cli/src/platform.dart';
import 'package:umbra_cli/src/workers/worker.dart';

/// {@template file_extractor}
/// Extracts a file from a list of bytes that represent an [Archive].
///
/// Assumes ZIP for Windows and TGZ for Linux and MacOS.
/// {@endtemplate}
class FileExtractor {
  /// {@macro file_extractor}
  FileExtractor({Platform? platform}) : _platform = platform ?? Platform();

  final Platform _platform;

  /// Extracts the file [path] from the given [bytes].
  Future<List<int>> extract(String path, List<int> bytes) async {
    final Archive archive;
    if (_platform.isMacOS || _platform.isLinux) {
      archive = await spawnWorker<Archive, List<int>>(_decodeTGZ, data: bytes);
    } else if (_platform.isWindows) {
      archive = await spawnWorker<Archive, List<int>>(_decodeZIP, data: bytes);
    } else {
      throw UnsupportedError('Unsupported platform.');
    }
    return archive.files.firstWhere((f) => f.name == path).content as List<int>;
  }
}

void _decodeTGZ(SendPort sendPort) {
  setupWorker(sendPort, (List<int> bytes) {
    return TarDecoder().decodeBytes(GZipDecoder().decodeBytes(bytes));
  });
}

void _decodeZIP(SendPort sendPort) {
  setupWorker(sendPort, ZipDecoder().decodeBytes);
}
