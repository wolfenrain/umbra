import 'package:test/test.dart';
import 'package:umbra_cli/src/workers/worker.dart';

void main() {
  group('spawnWorker', () {
    test('spawn worker and returns correct data', () async {
      final input = [1, 2, 3];
      final output = await spawnWorker<String, List<int>>(
        _testWorker,
        data: input,
      );

      expect(output, equals('[1, 2, 3]'));
    });

    test('fails to spawn worker with invalid input data', () async {
      const input = '[1, 2, 3]';

      await expectLater(
        () => spawnWorker<String, String>(_testWorker, data: input),
        throwsException,
      );
    });

    test('fails to complete worker with invalid returned data', () async {
      final input = [1, 2, 3];

      await expectLater(
        () => spawnWorker<String, List<int>>(_failingTestWorker, data: input),
        throwsException,
      );
    });
  });
}

void _testWorker(SendPort sendPort) {
  setupWorker(sendPort, (List<int> data) {
    return data.toString();
  });
}

void _failingTestWorker(SendPort sendPort) {
  setupWorker(sendPort, (List<int> data) {
    return data;
  });
}
