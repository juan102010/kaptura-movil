import 'package:flutter_kaptura/core/utils/map_diff.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getDifferentKeys', () {
    test('returns oldValue and newValue only for changed fields', () {
      final result = getDifferentKeys(
        {
          '_id': 'customer-id',
          'text_name_id': 'Nombre anterior',
          'text_mobile_id': '3051111111',
          'unchanged': true,
        },
        {
          '_id': 'customer-id',
          'text_name_id': 'Nombre nuevo',
          'text_mobile_id': '3052222222',
          'unchanged': true,
        },
      );

      expect(result, {
        'text_name_id': {
          'oldValue': 'Nombre anterior',
          'newValue': 'Nombre nuevo',
        },
        'text_mobile_id': {'oldValue': '3051111111', 'newValue': '3052222222'},
      });
    });

    test('detects added and removed fields and ignores metadata', () {
      final result = getDifferentKeys(
        {'removed': 'value', '__v': 1},
        {'added': 'new value', '__v': 2},
      );

      expect(result, {
        'removed': {'oldValue': 'value', 'newValue': ''},
        'added': {'oldValue': 'No Existe', 'newValue': 'new value'},
      });
    });

    test('compares nested collections by content', () {
      final result = getDifferentKeys(
        {
          'addresses': [
            {'city': 'Bogota'},
          ],
        },
        {
          'addresses': [
            {'city': 'Bogota'},
          ],
        },
      );

      expect(result, isEmpty);
    });
  });
}
