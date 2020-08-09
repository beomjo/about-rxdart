import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:matcher/matcher.dart';

/**
 * MapTo
 * 
 * 	소스 Stream이 값을 내보낼 때마다, 무조건 출력 Stream에서 주어진 상수 값을 내 보냅니다.
 */

main() {
  test('mapTo', () async {
    //given
    var a = Rx.range(1, 4);

    //when
    final result = a.mapTo(true);

    //then
    await expectLater(
      result,
      emitsInOrder(<dynamic>[
        true,
        true,
        true,
        true,
        emitsDone,
      ]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));

  test('mapTo with Error', () async {
    //given
    var a = Rx.range(1, 4).concatWith([Stream<int>.error(Error())]);

    //when
    final result = a.mapTo(true);

    //then
    await expectLater(
      result,
      emitsInOrder(<dynamic>[
        true,
        true,
        true,
        true,
        emitsError(TypeMatcher<Error>()),
        emitsDone,
      ]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));
}
