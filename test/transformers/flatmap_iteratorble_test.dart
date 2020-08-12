import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * FlatMapIteratorble
 * 
 * 각 항목을 Stream으로 변환합니다. Stream은 Iterable을 반환해야합니다. 
 * 그런 다음 Iterable의 각 항목이 하나씩 방출됩니다.
 * 
 * 사용 사례 : Stream <List와 같은 항목 목록을 반환하는 API가있을 수 있습니다.>. 
 * 그러나 목록 자체가 아닌 개별 항목에 대해 작업 할 수 있습니다.
 */

main() {
  test('flatMapIteratorble', () async {
    //given
    var a = Rx.range(1, 4);

    //when
    Stream<int> stream =
        a.flatMapIterable((int i) => Stream<List<int>>.value(<int>[i, i]));

    //then
    await expectLater(
        stream, emitsInOrder(<dynamic>[1, 1, 2, 2, 3, 3, 4, 4, emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
