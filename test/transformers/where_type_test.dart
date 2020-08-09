import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * WhereTyp
 * 
 * 조건의타입과 일치하지 않는 이벤트는 필터링되며 결과 Stream는 Type이 T됩니다.
 */

main() {
  test('WhereType', () async {
    // given
    final a = Stream.fromIterable([1, 'two', 3, 'four']);

    // when
    final result = a.whereType<int>();

    // then
    await expectLater(result, emitsInOrder([1, 3]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
