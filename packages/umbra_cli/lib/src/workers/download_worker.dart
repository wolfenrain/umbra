import 'dart:io';

import 'package:umbra_cli/src/workers/worker.dart';

/// {@template downloader}
/// Download worker that runs it in an isolate.
/// {@endtemplate}
class Downloader {
  /// {@macro downloader}
  const Downloader();

  /// Downloads the file from the given [url] as bytes.
  Future<List<int>> download(String url) async {
    return spawnWorker(_download, data: url);
  }
}

Future<void> _download(SendPort sendPort) async {
  setupWorker(sendPort, (String url) async {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    final bytes = (await response.toList()).fold<List<int>>(
      [],
      (p, e) => p..addAll(e),
    );
    return bytes;
  });
}
