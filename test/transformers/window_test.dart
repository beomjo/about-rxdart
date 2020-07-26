import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Window
 * 
 * 소스 Stream에서 수집 한 항목의 `창`을 내보내는 Stream을 반환합니다.
 * 출력 Stream은 겹치지 않는 연결된 `창`을 내 보냅니다.
 * Stream 항목을 내보낼 때마다 현재 `창`을 내보내고 새 `창`을 엽니다.
 * 각 `윈도우(창)`는 Stream이므로 출력은 상위 Stream입니다.( Stream<Stream>())
 * 
 * marble diagram  https://rxjs-dev.firebaseapp.com/api/operators/window
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
  test('window', () async {
    // given
    var a = getStream(4);

    // when
    Stream<List<int>> result = a
        .window(
            Stream<Null>.periodic(const Duration(milliseconds: 160)).take(3))
        .asyncMap((stream) => stream.toList());

    // then
    expectLater(
      result,
      emitsInOrder(<dynamic>[
        const [0, 1],
        const [2, 3],
        emitsDone,
      ]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));
}
