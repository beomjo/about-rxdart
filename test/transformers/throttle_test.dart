import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Throttle
 * 
 * 열려있는 Stream동안 소스에서 방출 한 첫 번째 항목 만 방출합니다
 * trailing 값을 사용하여 다음 처음 스로틀 을 시작할 시간을 결정할 수 있습니다.
 */

Stream<int> getStream() =>
    Stream.periodic(const Duration(milliseconds: 100), (i) => i + 1).take(10);

// throttle
// time      0ms    100ms    150ms    200ms    250ms    300ms    350ms    400ms    450ms    500ms    550ms    600ms    650ms    700ms
// source   |       1                 2                 3                 4                 5                 6                 7
// throttle |       1                                                     4                                                     7
// t_event  |       O                                            O                                            O

// throttle trailing=true
// time      0ms    100ms    150ms    200ms    250ms    300ms    350ms    400ms    450ms    500ms    550ms    600ms    650ms    700ms        
// source   |       1                 2                 3                 4                 5                 6                              
// throttle |                                           3                                                     6                                      
// t_event  |                                  O                                            O                                                

main() {
  test('throttle', () async {
    // given
    var a = getStream();

    // when
    Stream<int> result = a
        .throttle(
            (_) => Stream<void>.periodic(const Duration(milliseconds: 250)))
        .take(3);

    // then
    expectLater(
      result,
      emitsInOrder(<dynamic>[
        1,
        4,
        7,
        emitsDone,
      ]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));

  test('throttle,  trailing=true', () async {
    // given
    var a = getStream();

    // when
    Stream<int> result = a
        .throttle(
          (_) => Stream<void>.periodic(const Duration(milliseconds: 250)),
          trailing: true,
        )
        .take(3);

    // then
    expectLater(
      result,
      emitsInOrder(<dynamic>[
        3,
        6,
        9,
        emitsDone,
      ]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));
}
