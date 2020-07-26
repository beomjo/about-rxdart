import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * ThrottleTime
 * 
 * Stream의 시간 범위 내에 소스 에서 방출 한 첫 번째 항목 만 표시합니다.
 * 
 */

Stream<int> getStream() =>
    Stream.periodic(const Duration(milliseconds: 100), (i) => i + 1).take(10);

// throttle
// time      0ms    100ms    150ms    200ms    250ms    300ms    350ms    400ms    450ms    500ms    550ms    600ms    650ms    700ms
// source   |       1                 2                 3                 4                 5                 6                 7
// throttle |       1                                                     4                                                     7
// t_event  |       O                                            O                                            O

main() {
  test('throttleTime', () async {
    // given
    var a = getStream();

    // when
    Stream<int> result = a.throttleTime(Duration(milliseconds: 250)).take(3);

    // then
    await expectLater(
        result,
        emitsInOrder(<dynamic>[
          1,
          4,
          7,
          emitsDone,
        ]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
