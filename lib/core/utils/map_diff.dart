const Set<String> defaultMapDiffIgnoredKeys = {
  '_id',
  'description',
  'estado',
  'icon',
  'nombre',
  '__v',
};

/// Compares a record before and after an edit and returns the payload expected
/// by `/api/dynamicRow/update-row`.
Map<String, Map<String, dynamic>> getDifferentKeys(
  Map<String, dynamic> before,
  Map<String, dynamic> after, {
  Set<String> ignoredKeys = defaultMapDiffIgnoredKeys,
}) {
  final differences = <String, Map<String, dynamic>>{};
  final keys = <String>{...before.keys, ...after.keys};

  for (final key in keys) {
    if (ignoredKeys.contains(key)) continue;

    final existedBefore = before.containsKey(key);
    final existsAfter = after.containsKey(key);
    final oldValue = before[key] ?? '';
    final newValue = after[key] ?? '';

    if (existedBefore && existsAfter && deepEquals(oldValue, newValue)) {
      continue;
    }

    if (!existedBefore && newValue == '') continue;

    differences[key] = {
      'oldValue': existedBefore ? oldValue : 'No Existe',
      'newValue': newValue,
    };
  }

  return differences;
}

bool deepEquals(Object? first, Object? second) {
  if (first is Map && second is Map) {
    if (first.length != second.length) return false;
    return first.keys.every(
      (key) => second.containsKey(key) && deepEquals(first[key], second[key]),
    );
  }

  if (first is List && second is List) {
    if (first.length != second.length) return false;
    for (var index = 0; index < first.length; index++) {
      if (!deepEquals(first[index], second[index])) return false;
    }
    return true;
  }

  if (first is Set && second is Set) {
    if (first.length != second.length) return false;
    return first.every(
      (item) => second.any((candidate) => deepEquals(item, candidate)),
    );
  }

  return first == second;
}
