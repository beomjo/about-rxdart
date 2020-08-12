import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * BufferTime
 * 
 * 각 항목이 Stream소스 시퀀스의 항목을 포함 하는 스트림을 생성하고
 * 주어진시간마다 샘플링하여 창을 내보냅니다.
 */

Stream<int> getStream(int n) async* {
  var k = 0;

  while (k < n) {
    await Future<Null>.delayed(const Duration(milliseconds: 100));

    yield k++;
  }
}

// time    0ms    100ms    150ms    200ms    250ms    300ms    350ms    400ms    450ms    500ms    550ms    600ms
// source |       0                 1                 2                 3                 4
// window |       0                              1                         2                                     3

main() {
  test('지정된 시간(160ms)동안 버퍼에 쌓고 방출해야한다', () async {
    // given
    var a = getStream(4);

    // when
    Stream<List<int>> result = a
        .bufferTime(Duration(milliseconds: 160))
        .asyncMap((stream) => stream.toList());

    // then
    await expectLater(
        result,
        emitsInOrder(<dynamic>[
          const [0, 1],
          const [2, 3],
          emitsDone
        ]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
