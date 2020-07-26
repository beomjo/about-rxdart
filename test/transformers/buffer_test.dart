import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Buffer
 * 
 * 각 항목이 List를 방출하는 스트림을 만들어 window이벤트를 방출합니다.
 */

Stream<int> getStream(int n) async* {
  var k = 0;

  while (k < n) {
    await Future<Null>.delayed(const Duration(milliseconds: 100));

    yield k++;
  }
}

main() {
  test('Buffer', () async {
    // given
    var a = getStream(4);

    // when
    final result = a.buffer(
        Stream<Null>.periodic(const Duration(milliseconds: 160)).take(3));

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
