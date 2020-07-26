import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Buffer
 * 
 * 각 항목이 Stream소스 시퀀스의 항목을 포함 하는 스트림 을 작성하고 테스트(조건)을 통과 될 때마다 일괄 처리합니다.
 */

Stream<int> getStream(int n) async* {
  var k = 0;

  while (k < n) {
    await Future<Null>.delayed(const Duration(milliseconds: 100));

    yield k++;
  }
}

main() {
  test('bufferTest', () async {
    // given
    var a = Rx.range(0, 4);

    // when
    Stream<List<int>> result =
        a.bufferTest((i) => i % 2 == 0).asyncMap((stream) => stream.toList());

    // then
    expectLater(
      result,
      emitsInOrder(<dynamic>[
        const [0],
        const [1, 2],
        const [3, 4],
        emitsDone,
      ]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));

  test('windowTest Transformer', () async {
    // given
    var a = Rx.range(0, 4);
    final transformer = BufferTestStreamTransformer<int>((i) => i % 2 == 0);

    // when
    Stream<List<int>> result =
        a.transform(transformer).asyncMap((stream) => stream.toList());

    // then
    expectLater(
      result,
      emitsInOrder(<dynamic>[
        const [0],
        const [1, 2],
        const [3, 4],
        emitsDone,
      ]),
    );
  }, timeout: Timeout(Duration(seconds: 5)));
}
