import 'dart:io';

import 'package:test/test.dart';

Matcher matchesFixture(File file) {
  return _FixtureMatcher(file.readAsBytesSync());
}

class _FixtureMatcher extends Matcher {
  _FixtureMatcher(List<int> expected)
      : _expected = String.fromCharCodes(expected);

  final String _expected;

  @override
  bool matches(Object? actual, Map matchState) {
    if (actual is List<int>) {
      final actualString = String.fromCharCodes(actual);
      if (actualString == _expected) {
        return true;
      }
      addStateInfo(matchState, <String, dynamic>{'mismatch': actualString});
      return false;
    }
    addStateInfo(
      matchState,
      <String, dynamic>{'wrong_type': actual.runtimeType},
    );
    return false;
  }

  @override
  Description describe(Description description) =>
      description.addDescriptionOf(_expected);

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (matchState.containsKey('mismatch')) {
      final mismatch = matchState['mismatch'] as String;
      return mismatchDescription.add('represents ').addDescriptionOf(mismatch);
    }
    if (matchState.containsKey('wrong_type')) {
      final wrongType = matchState['wrong_type'] as Object;
      return mismatchDescription.add('is a ').addDescriptionOf(wrongType);
    }
    return mismatchDescription;
  }
}
