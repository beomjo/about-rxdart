import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * WindowCount
 * 
 * 소스 Stream에서 여러 값을 count버퍼링 한 다음 창 a로 내보내고 
 * Stream은 각 startBufferEvery값 마다 새 창 시작 합니다. 
 * 경우에는 startBufferEvery제공하지 않으면 
 * 새로운 count갯수 때마다 창이 닫히고 방출됩니다
 * 
 */

Stream<int> getStream(int n) async* {
  var k = 0;

  while (k < n) {
    await Future<Null>.delayed(const Duration(milliseconds: 100));

    yield k++;
  }
}

main() {
  test('2개를 카운트하여 새 창을 열어야한다', () async {
    // given
    var a = Rx.range(0, 4);

    // when
    Stream<List<int>> result =
        a.windowCount(2).asyncMap((stream) => stream.toList());

    // then
    await expectLater(
        result,
        emitsInOrder(<dynamic>[
          const [0, 1],
          const [2, 3],
          const [4],
          emitsDone
        ]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('2개를 카운트하여 새 창을 열고, startBufferEvery값부터 다시 창을 열기 시작해야한다 ', () async {
    // given
    var a = Rx.range(0, 4);

    // when
    Stream<List<int>> result =
        a.windowCount(2, 1).asyncMap((stream) => stream.toList());

    // then
    await expectLater(
        result,
        emitsInOrder(<dynamic>[
          const [0, 1],
          const [1, 2],
          const [2, 3],
          const [3, 4],
          const [4],
          emitsDone
        ]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('windowCount count3, startBufferEvery2', () async {
    // given
    var a = Rx.range(0, 8);

    // when
    Stream<List<int>> result =
        a.windowCount(3, 2).asyncMap((stream) => stream.toList());

    // then
    await expectLater(
        result,
        emitsInOrder(<dynamic>[
          const [0, 1, 2],
          const [2, 3, 4],
          const [4, 5, 6],
          const [6, 7, 8],
          const [8],
          emitsDone
        ]));
  }, timeout: Timeout(Duration(seconds: 5)));

  test('windowCount count3, startBufferEvery4', () async {
    // given
    var a = Rx.range(0, 8);

    // when
    Stream<List<int>> result =
        a.windowCount(3, 4).asyncMap((stream) => stream.toList());

    // then
    await expectLater(
        result,
        emitsInOrder(<dynamic>[
          const [0, 1, 2],
          const [4, 5, 6],
          const [8],
          emitsDone
        ]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
