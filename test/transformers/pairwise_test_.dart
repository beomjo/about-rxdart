import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Pairwise
 * 
 * n 번째 및 n-1 번째 이벤트를 쌍으로 표시합니다.
 */

Stream<int> getStream(int n) async* {
  var k = 0;

  while (k < n) {
    await Future<Null>.delayed(const Duration(milliseconds: 100));

    yield k++;
  }
}

main() {
  test('Pairwise', () async {
    // given
    var a = Rx.range(0, 4);

    // when
    Stream<List<int>> result = a.pairwise();

    // then
    await expectLater(
        result,
        emitsInOrder(<dynamic>[
          const [0, 1],
          const [1, 2],
          const [2, 3],
          const [3, 4],
          emitsDone
        ]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
