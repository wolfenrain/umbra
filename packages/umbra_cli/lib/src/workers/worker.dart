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
  final errorPort = ReceivePort();
  final receivePort = ReceivePort();
  late final StreamSubscription<void> errorSubscription;
  late final StreamSubscription<void> subscription;
  late final Isolate isolate;

  void cleanUp() {
    isolate.kill();
    receivePort.close();
    subscription.cancel();
    errorSubscription.cancel();
  }

  errorSubscription = errorPort.listen((dynamic error) {
    cleanUp();
    final errorMessage = (error as List).first as String;
    completer.completeError(Exception(errorMessage));
  });

  subscription = receivePort.listen((dynamic message) {
    if (message is SendPort) {
      message.send(data);
    } else if (message is T) {
      cleanUp();
      completer.complete(message);
    } else {
      completer.completeError(
        Exception('Expected type ${T.toString()} not ${message.runtimeType}'),
      );
    }
  });

  isolate = await Isolate.spawn(worker, receivePort.sendPort)
    ..addErrorListener(errorPort.sendPort);
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
        // ignore: only_throw_errors
        throw 'Expected type $V not ${message.runtimeType} for worker data';
      }
      sendPort.send(await worker(message));
    });

  sendPort.send(receivePort.sendPort);
}
