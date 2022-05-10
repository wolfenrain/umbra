import 'dart:io';

import 'package:umbra_cli/src/workers/worker.dart';

/// {@template file_writer}
/// Write bytes to a file in a separate isolate.
/// {@endtemplate}
class FileWriter {
  /// {@macro file_writer}
  const FileWriter();

  /// Writes [bytes] to a [file].
  Future<void> write(File file, List<int> bytes) async {
    return spawnWorker(_write, data: [bytes, file]);
  }
}

void _write(SendPort sendPort) {
  setupWorker(sendPort, (List<dynamic> input) async {
    final bytes = input.first as List<int>;
    final file = input.last as File;

    await file.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
  });
}
