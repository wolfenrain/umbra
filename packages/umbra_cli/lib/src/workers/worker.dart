import 'dart:async';

import 'dart:isolate';

export 'dart:isolate' show SendPort;

/// Spawn an isolate that will execute the [worker] function.
///
/// The [worker] function has to call the [setupWorker] function to setup the
/// bi-directional communication channel.
///
/// **Note**: The [worker] function has to be a top-level function.
Future<T> spawnWorker<T, V>(
  FutureOr<void> Function(SendPort) worker, {
  required V data,
}) async {
  final completer = Completer<T>();
  final receivePort = ReceivePort();
  late final StreamSubscription<void> subscription;
  late final Isolate isolate;

  subscription = receivePort.listen((dynamic message) {
    if (message is SendPort) {
      message.send(data);
    } else if (message is T) {
      isolate.kill();
      receivePort.close();
      subscription.cancel();
      completer.complete(message);
    } else {
      throw Exception(
        'Expected type ${T.toString()} not ${message.runtimeType}',
      );
    }
  });

  isolate = await Isolate.spawn(worker, receivePort.sendPort);
  return completer.future;
}

/// Setup the bi-directional communication channel between the worker isolate
/// and the calling isolate.
void setupWorker<T, V>(
  SendPort sendPort,
  FutureOr<T> Function(V data) worker,
) {
  final receivePort = ReceivePort()
    ..listen((dynamic message) async {
      if (message is! V) {
        throw Exception(
          'Expected type $V not ${message.runtimeType} for worker data',
        );
      }
      sendPort.send(await worker(message));
    });

  sendPort.send(receivePort.sendPort);
}
