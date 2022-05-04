import 'package:mason/mason.dart';
import 'package:test/test.dart';
import 'package:umbra_core/src/generators/in_memory_generator_target.dart';

void main() {
  group('InMemoryGeneratorTarget', () {
    test('', () async {
      final target = InMemoryGeneratorTarget();

      final result = await target.createFile('test.path', [1, 2, 3]);

      expect(result.status, GeneratedFileStatus.skipped);
      expect(
        target.generatedFiles,
        equals({
          'test.path': [1, 2, 3],
        }),
      );
    });
  });
}
