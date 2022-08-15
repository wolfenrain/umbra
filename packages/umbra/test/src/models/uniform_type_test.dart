import 'package:test/test.dart';
import 'package:umbra/umbra.dart';

void main() {
  group('UniformType', () {
    test('throws an exception when the uniform type is not supported', () {
      expect(
        () => UniformType.parse('fake'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
