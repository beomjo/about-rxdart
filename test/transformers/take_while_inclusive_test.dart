import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * TakeWhilInclusive
 * 
 * 각 값이 주어진 테스트(조건)를 충족할때까지만 소스 스트림에서 값을 내 보냅니다.
 * 테스트가 값으로 만족되지 않으면이 값을 모두 내보냅니다.
 */

main() {
  test('조건을 만족할때까지만 소스스트림의 값을 내보내야한다', () async {
    // given
    final a = Stream.fromIterable([2, 3, 4, 5, 6, 1, 2, 3]);

    // when
    final result = a.takeWhileInclusive((i) => i < 4);

    // then
    await expectLater(result, emitsInOrder([2, 3]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('TakeWhilInclusive 조건에 일치하는 값이 없을때, 소스스트림의 첫 번째 값을 방출한다', () async {
    // given
    final a = Stream.fromIterable([2, 3, 4, 5, 6, 1, 2, 3]);

    // when
    final result = a.takeWhileInclusive((i) => i > 9);

    // then
    await expectLater(result, emitsInOrder([2]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
