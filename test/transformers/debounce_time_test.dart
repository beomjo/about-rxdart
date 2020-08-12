import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * DebounceTime
 * 
 * Stream소스 시퀀스가 지정한 시간동안 
 * 다른 항목을 방출하지 않고 완료된 경우에만 소스 시퀀스에서 항목을 방출하도록을 변환합니다.
 */

Stream<int> getStream() {
  final controller = StreamController<int>();

  Timer(const Duration(milliseconds: 100), () => controller.add(1));
  Timer(const Duration(milliseconds: 200), () => controller.add(2));
  Timer(const Duration(milliseconds: 300), () => controller.add(3));
  Timer(const Duration(milliseconds: 400), () {
    controller.add(4);
    controller.close();
  });

  return controller.stream;
}

// time      0ms    100ms    150ms    200ms    250ms    300ms    350ms    400ms    450ms    500ms    550ms    600ms    650ms    700ms    750ms    800ms    850ms    900ms
// source   |       1                 2                 3                 4                                                                                             
// debounce |       ------------------------------------> ----------------------------------> ----------------------------------> ---------------------------------> 4

main() {
  test('200ms동안 값이 방출되지 않았을때, 값을 방출한다 ', () async {
    // given
    var a = getStream();

    // when
    final result = a.debounceTime(Duration(milliseconds: 200));

    // then
    await expectLater(result, emitsInOrder(<dynamic>[4, emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
