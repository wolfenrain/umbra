import 'dart:io';
import 'package:collection/collection.dart';

bool filesEqual(File? a, File? b) {
  if (identical(a, b)) return true;
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;

  return const ListEquality<int>()
      .equals(a.readAsBytesSync(), b.readAsBytesSync());
}
