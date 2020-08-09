import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

/**
 * ExhaustMap
 * 
 * 지정된 매퍼를 사용하여 소스 스트림의 항목들을 Stream으로 변환합니다. 
 * 새 스트림이 완료 될 때까지 소스 스트림의 모든 항목을 무시합니다.
 * 소스 스트림의 이전 비동기 작업이 완료된 후에 만 ​​응답하려는 경우 유용합니다.
 */

main() {
  test('MapperStream을 방출하는 동안 소스스트림을 무시해야한다', () async {
    //given
    var calls = 0;
    var a = Rx.range(0, 9);

    //when
    final stream = a.exhaustMap((i) {
      calls++;
      return Rx.timer(i, Duration(milliseconds: 100));
    });

    //then
    await expectLater(stream, emitsInOrder(<dynamic>[0, emitsDone]));
    await expectLater(calls, 1);
  }, timeout: Timeout(Duration(seconds: 5)));

  test('MapperStream을 방출하는 동안 소스스트림을 무시해야한다 2', () async {
    //given
    var a = Stream.fromIterable(const [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);

    //when
    final stream =
        a.interval(Duration(milliseconds: 30)).exhaustMap((i) async* {
      yield await Future.delayed(Duration(milliseconds: 70), () => i);
    });

    //then
    await expectLater(stream, emitsInOrder(<dynamic>[0, 3, 6, 9, emitsDone]));
  }, timeout: Timeout(Duration(seconds: 5)));
}
