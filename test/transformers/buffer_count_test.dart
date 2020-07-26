import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * BufferCount
 * 
 * 소스 스트림에서 count만큼 버퍼링 한 다음 버퍼를 내보내고 지운 후
 * Stream은 각 startBufferEvery값 마다 새 버퍼를 시작 합니다.
 * startBufferEvery제공하지 경우에는,새로운 버퍼는 소스의 개시 때마다 버퍼가 닫히고 즉시 방출됩니다.
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
  test('bufferCount', () async {
    // given
    var a = Rx.range(0, 4);

    // when
    Stream<List<int>> result =
        a.bufferCount(2).asyncMap((stream) => stream.toList());

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

  test('bufferCount count2, startBufferEvery1', () async {
    // given
    var a = Rx.range(0, 4);

    // when
    Stream<List<int>> result =
        a.bufferCount(2, 1).asyncMap((stream) => stream.toList());

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

  test('bufferCount count3, startBufferEvery2', () async {
    // given
    var a = Rx.range(0, 8);

    // when
    Stream<List<int>> result =
        a.bufferCount(3, 2).asyncMap((stream) => stream.toList());

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

  test('bufferCount count3, startBufferEvery4', () async {
    // given
    var a = Rx.range(0, 8);

    // when
    Stream<List<int>> result =
        a.bufferCount(3, 4).asyncMap((stream) => stream.toList());

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
