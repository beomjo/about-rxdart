import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * FlatMap
 * 
 * 주어진 매퍼 함수를 ​​사용하여 방출 된 각 항목을 Stream으로 변환합니다.
 * 새로 생성 된 Stream이 수신되고 항목을 다운 스트림으로 방출하기 시작합니다.
 * 각 스트림에서 방출되는 항목은 도착한 순서대로 다운 스트림으로 방출됩니다. 즉, 시퀀스가 ​​함께 병합됩니다.
 */

main() {
  Stream<int> _getStream() => Stream.fromIterable(const [1, 2, 3]);

  Stream<int> _getOtherStream(int value) {
    final controller = StreamController<int>();

    Timer(
        // Reverses the order of 1, 2, 3 to 3, 2, 1 by delaying 1, and 2 longer
        // than they delay 3
        Duration(milliseconds: value == 1 ? 15 : value == 2 ? 10 : 5), () {
      controller.add(value);
      controller.close();
    });

    return controller.stream;
  }

  test('flatMap', () async {
    //given
    var a = _getStream();

    //when
    final stream = a.flatMap(_getOtherStream);

    //then
    await expectLater(stream, emitsInOrder([3, 2, 1, emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
