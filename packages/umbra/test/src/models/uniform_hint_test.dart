import 'package:test/test.dart';
import 'package:umbra/umbra.dart';

void main() {
  group('UniformHint', () {
    test('can be parsed', () {
      final uniform = UniformHint.parse('color');

      expect(uniform?.key, equals('color'));
    });

    test('is equal to itself', () {
      final uniform = UniformHint.parse('color');

      expect(uniform, isNotNull);
      expect(uniform!.props, equals(UniformHint.parse('color')!.props));
    });

    test('color hint', () {
      final uniform = UniformHint.parse('color');

      expect(uniform?.key, equals('color'));
      expect(uniform?.isValidType(UniformType.vec4), isTrue);
    });
  });
}
