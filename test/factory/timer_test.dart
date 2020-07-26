import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Timer
 * 
 * 지정된 시간이 지나면 주어진 값을 방출합니다.
 */

main() {
  test('타이머', () async {
    // given
    const value = 1;

    // when
    final stream = TimerStream(value, Duration(milliseconds: 1));

    // then
    await expectLater(stream, emitsInOrder(<dynamic>[value, emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('타이머는 단일 구독이여야 한다', () async {
    // given
    const value = 1;

    // when
    final stream = TimerStream(value, Duration(milliseconds: 1));
    stream.listen(null);

    // then
    await expectLater(() => stream.listen(null), throwsA(isStateError));
  }, timeout: Timeout(Duration(seconds: 5)));
}
