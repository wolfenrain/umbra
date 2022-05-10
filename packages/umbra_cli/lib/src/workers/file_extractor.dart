import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:umbra_cli/src/workers/worker.dart';

/// {@template file_extractor}
/// Extracts a file from a list of bytes that represent an [Archive].
///
/// Assumes ZIP for Windows and TGZ for Linux and MacOS.
/// {@endtemplate}
class FileExtractor {
  /// {@macro file_extractor}
  const FileExtractor();

  /// Extracts the file from the given [bytes].
  Future<List<int>> extract(String file, List<int> bytes) async {
    final archive = await spawnWorker<Archive, List<int>>(_decode, data: bytes);

    return archive.files.firstWhere((f) => f.name == file).content as List<int>;
  }
}

void _decode(SendPort sendPort) {
  setupWorker(sendPort, (List<int> bytes) {
    final Archive archive;
    if (Platform.isMacOS || Platform.isLinux) {
      archive = TarDecoder().decodeBytes(GZipDecoder().decodeBytes(bytes));
    } else if (Platform.isWindows) {
      archive = ZipDecoder().decodeBytes(bytes);
    } else {
      throw UnsupportedError('Unsupported platform.');
    }
    return archive;
  });
}
