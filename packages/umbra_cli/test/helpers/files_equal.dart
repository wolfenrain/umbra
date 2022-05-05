import 'dart:io';

bool filesEqual(File? a, File? b) {
  if (identical(a, b)) return true;
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;

  return a.readAsStringSync() == b.readAsStringSync();
}
