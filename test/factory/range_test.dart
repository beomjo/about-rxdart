import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:matcher/matcher.dart';

/**
 * Range
 * 
 * 지정된 범위 내에서 일련의 정수를 방출하는 Stream을 반환합니다.
 * 
 */

main() {
  test('Range', () async {
    // given

    // when
    final stream = Rx.range(1, 3);

    // then
    await expectLater(stream, emitsInOrder([1, 2, 3, emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('Range는 단일구독만 가능해야한다', () async {
    // given

    // when
    final stream = Rx.range(1, 5);

    // then
    stream.listen(null);
    await expectLater(() => stream.listen(null), throwsA(isStateError));
  }, timeout: Timeout(Duration(seconds: 5)));
  test('Range start와 end가 같으면 1개의 항목만 방출해야한다', () async {
    // given

    // when
    final stream = Rx.range(1, 1);

    // then
    stream.listen(expectAsync1((actual) {
      expect(actual, 1);
    }, count: 1));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('Range 역순으로 배출해야한다', () async {
    // given

    // when
    final stream = Rx.range(3, 1);

    // then
    await expectLater(stream, emitsInOrder([3, 2, 1, emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
